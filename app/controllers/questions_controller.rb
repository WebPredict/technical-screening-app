class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy, :make_easy, :make_medium, :make_hard]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  before_action :admin_user,     only: [:make_easy, :make_medium, :make_hard]

  include QuestionsHelper 
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Questions", :questions_path
  
  def index
    query = ''
    searchparam = ""
    @questions = nil
    if !params[:remember_search].blank? && !session[:question_search].blank?
      params[:search] = session[:question_search]
    end
    
    @categories = Category.all
    
    if !params[:search].blank?
        query = ' lower(content) LIKE ? OR lower(answer) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
        @questions = Question.where(query, searchparam, searchparam).joins(:category)
    else
      @questions = Question.all.joins(:category)
    end
    session[:question_search] = params[:search]
    
    if !params[:remember_search].blank? && !session[:question_category].blank?
      params[:category_id] = session[:question_category]
    end
    
    if !params[:category].blank?
      found_cat = Category.where("name = ?", params[:category])
      if found_cat.any?
        params[:category_id] = found_cat.first.id
      else
        params[:category_id] = "0"
      end
    end
    
    if !params[:category_id].blank?
      query = ' category_id = ? '
      
      if params[:category].blank?
        params[:category] = Category.find(params[:category_id]).name
      end
      
      @questions = @questions.where(query, params[:category_id])
    end
    session[:question_category] = params[:category_id]
    
    if !params[:remember_search].blank? && !session[:question_difficulty].blank?
      params[:difficulty_id] = session[:question_difficulty]
    end
    if !params[:difficulty_id].blank?
      query = ' difficulty_id = ? '
      @questions = @questions.where(query, params[:difficulty_id])
    end
    session[:question_difficulty] = params[:difficulty_id]

    only_mine = params[:only_my_questions]
    
    if current_user != nil
      if only_mine.blank?
        @questions = @questions.where("is_public = ? OR user_id = ?", true, current_user.id).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
      else
        @questions = @questions.where("user_id = ?", current_user.id).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
      end
    else
      @questions = @questions.where("is_public = ?", true).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    end
    
    @select_mode = false
    @searched = query != ''
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      
      if current_user.membership_level_id == 1 && current_user.questions.any? && 
        current_user.questions.count > Limits::MAX_QUESTIONS_FREE
        flash[:info] = "Limit for number of questions for free membership level is: " + Limits::MAX_QUESTIONS_FREE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 2 && current_user.questions.any? && 
        current_user.questions.count > Limits::MAX_QUESTIONS_BRONZE
        flash[:info] = "Limit for number of questions for Bronze membership level is: " + Limits::MAX_QUESTIONS_BRONZE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 3 && current_user.questions.any? && 
        current_user.questions.count > Limits::MAX_QUESTIONS_GOLD
        flash[:info] = "Limit for number of questions for Gold membership level is: " + Limits::MAX_QUESTIONS_GOLD.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif !current_user.admin? && current_user.membership_level_id == 4 && current_user.questions.any? && 
        current_user.questions.count > Limits::MAX_QUESTIONS_PLATINUM
        flash[:info] = "Limit for number of questions for Platinum membership level is: " + Limits::MAX_QUESTIONS_PLATINUM.to_s + 
        ". Contact us to increase your limit!"
        redirect_to plans_path
      else

        @question = current_user.questions.build(question_params)
        
        if @question.is_public?
          num_existing = Question.where("is_public = ? AND content = ?", true, @question.content).count
          if num_existing > 0
            flash.now[:warning] = "This public question already exists. Please use that question or modify this one to avoid creating a duplicate."
            render 'new'
            return
          end
        end
      
        session[:question_type_id] = @question.question_type_id
        session[:category_id] = @question.category_id
        session[:difficulty_id] = @question.difficulty_id

        if @question.question_type_id == 2
          if params[:question][:multiple_choice_answer].blank?
            flash.now[:warning] = "You must select an answer for a multiple choice question."
            render 'new'
            return
          else
            full_question = @question.content + "||" + params[:question][:answer2] + "||" + params[:question][:answer3] + "||" + 
              params[:question][:answer4] + "||" + params[:question][:answer5]
            @question.content = full_question
            @question.answer = params[:question][:multiple_choice_answer]
            @question.save
          end
        elsif @question.question_type_id == 3
          @question.answer = params[:question][:short_answer]
          @question.save 
        end 
        
        if @question.save
          flash[:success] = "Question created!"
          redirect_to @question
        else
          @candidates = current_user.candidates
          render 'new'
        end
      end
    end
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      @question = Question.find(params[:id])
      respond_to do |format|
        if @question.update_attributes(question_params)
          
          if @question.question_type_id == 2
            full_question = @question.content + "||" + params[:question][:answer2] + "||" + params[:question][:answer3] + "||" + 
              params[:question][:answer4] + "||" + params[:question][:answer5]
            @question.content = full_question
            @question.answer = params[:question][:multiple_choice_answer]
            @question.save
          elsif @question.question_type_id == 3
            @question.answer = params[:question][:short_answer]
            @question.save 
          end 

          format.html { 
            flash[:success] = "Question was successfully updated."
            if params[:commit] == "Save And Goto Next TODO"
              @question = Question.where("lower(answer) LIKE ?", "%todo%").first
              setup_question(@question)
    
              add_breadcrumb "Edit Question", edit_question_path
              render 'edit'
            else
              if params[:commit] == "Save And Return To Search"
                redirect_to questions_path(:remember_search => "true")
              else
                redirect_to @question
              end
            end
          }
          format.json { render :show, status: :ok, location: @question }
        else
          format.html { render :edit }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def new
    @question = Question.new
    
    if !session[:question_type_id].blank?
      @question.question_type_id = session[:question_type_id]
    end
    if !session[:difficulty_id].blank?
      @question.difficulty_id = session[:difficulty_id]
    end
    if !session[:question_category].blank?
      @question.category_id = session[:question_category]
    end
    if !session[:category_id].blank?
      @question.category_id = session[:category_id]
    end

    flash.now[:info] = "Multiple choice and short phrase questions can be automatically scored. The chosen difficulty level does not affect scoring."
    add_breadcrumb "New Question", new_question_path
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])

    setup_question(@question)
    
    add_breadcrumb "Edit Question", edit_question_path
  end

  def make_easy
    @question = Question.find(params[:id])
    @question.difficulty_id = 1
    @question.save
    flash[:info] = "Question updated to easy."
    redirect_to questions_path
  end
  
  def next_question
    @question = Question.find(params[:id].to_i + 1)
    redirect_to @question
  end
  
  def random_question
    count = Question.all.count
    @question = Question.find(Random.rand(count) + 1)
    redirect_to @question
  end
  
  def make_medium
    @question = Question.find(params[:id])
    @question.difficulty_id = 2
    @question.save
    flash[:info] = "Question updated to medium."
    redirect_to questions_path
  end
  
  def make_hard
    @question = Question.find(params[:id])
    @question.difficulty_id = 3
    @question.save
    flash[:info] = "Question updated to hard."
    redirect_to questions_path
  end
  
  def show
    @question = Question.find(params[:id])
    if @question.question_type_id == 2
      split_answers = @question.content.split("||")
      @question_part_content = split_answers [0]
      if split_answers.size > 1
        @question.answer2 = split_answers [1]
      end 
      if split_answers.size > 2
        @question.answer3 = split_answers [2]
      end 
      if split_answers.size > 3
        @question.answer4 = split_answers [3]
      end 
      if split_answers.size > 4
        @question.answer5 = split_answers [4]
      end 
    end
    add_breadcrumb "Show Question", question_path
  end

  def clone_question
    @question = Question.find(params[:id])
    @clone_question = Question.new
    @clone_question.content = @question.content
    @clone_question.answer = @question.answer
    @clone_question.difficulty_id = @question.difficulty_id
    @clone_question.category_id = @question.category_id
    @clone_question.question_type_id = @question.question_type_id
    @clone_question.is_public = false
    @clone_question.user = current_user
    setup_question(@clone_question)
    flash.now[:success] = "Question cloned. You can change any details you'd like."

    @question = @clone_question
    add_breadcrumb "Cloned Question", new_question_path
    render 'new'
  end
  
  def destroy
    if !@question.tests.any?
      @question.destroy
      flash[:success] = "Question deleted."
      redirect_to questions_path
    else
      flash[:warning] = "Cannot delete this question because it has tests using it."
      redirect_to request.referrer
    end
  end

  private

    def question_params
      params.require(:question).permit(:difficulty_id, :category_id, :question_type_id, :content, 
      :answer, :answer2, :answer3, :answer4, :answer5, :short_answer, :multiple_choice_answer, 
      :is_public, :only_my_questions)
    end
    
    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      if @question.nil? && current_user.admin?
        @question = Question.find(params[:id])
      end
      
      redirect_to root_url if @question.nil?
    end
  
    def sort_column
      (Question.column_names.include?(params[:sort]) || params[:sort] == "categories.name") ? params[:sort] : "categories.name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end

