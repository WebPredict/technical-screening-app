class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
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
    
    if !params[:search].blank?
        query = ' lower(content) LIKE ? OR lower(answer) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
        @questions = Question.where(query, searchparam, searchparam)
        session[:question_search] = params[:search]
    else
      @questions = Question.all
    end

    if !params[:remember_search].blank? && !session[:question_category].blank?
      params[:category_id] = session[:question_category]
    end
    if !params[:category_id].blank?
      query = ' category_id = ? '
      
      @questions = @questions.where(query, params[:category_id])
      session[:question_category] = params[:category_id]
    end
    
    if !params[:remember_search].blank? && !session[:question_difficulty].blank?
      params[:difficulty_id] = session[:question_difficulty]
    end
    if !params[:difficulty_id].blank?
      query = ' difficulty_id = ? '
      @questions = @questions.where(query, params[:difficulty_id])
      session[:question_difficulty] = params[:difficulty_id]
    end

    if current_user != nil
      @questions = @questions.where("is_public = ? OR user_id = ?", true, current_user.id).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
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
      @question = current_user.questions.build(question_params)
      
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
      
      if @question.save
        flash[:success] = "Question created!"
        redirect_to @question
      else
        @candidates = current_user.candidates
        render 'new'
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
              @question = Question.where("lower(answer) LIKE ? OR lower(answer) LIKE ?", "%todo%", "%answer%").first
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
    flash.now[:info] = "Multiple choice and short answer questions can be automatically scored. The chosen difficulty level does not affect scoring."
    add_breadcrumb "New Question", new_question_path
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])

    setup_question(@question)
    
    add_breadcrumb "Edit Question", edit_question_path
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
      redirect_to request.referrer || root_url
    else
      flash[:warning] = "Cannot delete this question because it has tests using it."
      redirect_to request.referrer
    end
  end

  private

    def question_params
      params.require(:question).permit(:difficulty_id, :category_id, :question_type_id, :content, 
      :answer, :answer2, :answer3, :answer4, :answer5, :short_answer, :multiple_choice_answer, :is_public)
    end
    
    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      if @question.nil? && current_user.admin?
        @question = Question.find(params[:id])
      end
      
      redirect_to root_url if @question.nil?
    end
  
    def sort_column
      Question.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

