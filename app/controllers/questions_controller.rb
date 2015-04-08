class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Questions", :questions_path
  
  def index
    query = ''
    searchparam = ""
    @questions = nil
    if params[:search] && params[:search] != ''
        query = ' lower(content) LIKE ? OR lower(answer) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
        @questions = Question.where(query, searchparam, searchparam)
    else
      @questions = Question.all
    end

    if params[:category_id] && params[:category_id] != ''
      query = ' category_id = ? '
      
      @questions = @questions.where(query, params[:category_id])
    end
    
    if params[:difficulty_id] && params[:difficulty_id] != ''
      query = ' difficulty_id = ? '
      @questions = @questions.where(query, params[:difficulty_id])
    end

    @questions = @questions.paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
  
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
            redirect_to @question
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
    add_breadcrumb "New Question", new_question_path
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    
    split_answers = @question.content.split("||")
    @question.content = split_answers [0]
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
    
    if @question.question_type_id == 3
      @question.short_answer = @question.answer
    end
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
    @clone_question.content = "CLONE - " + @question.content
    @clone_question.answer = @question.answer
    @clone_question.difficulty_id = @question.difficulty_id
    @clone_question.category_id = @question.category_id
    @clone_question.question_type_id = @question.question_type_id
    @clone_question.user = current_user
    @clone_question.save
    flash[:success] = "Question cloned."
    redirect_to edit_question_path(@clone_question)
  end
  
  def destroy
    @question.destroy
    flash[:success] = "Question deleted."
    redirect_to request.referrer || root_url
  end

  private

    def question_params
      params.require(:question).permit(:difficulty_id, :category_id, :question_type_id, :content, 
      :answer, :answer2, :answer3, :answer4, :answer5, :short_answer, :multiple_choice_answer)
    end
    
    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to root_url if @question.nil?
    end
  
    def sort_column
      Question.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

