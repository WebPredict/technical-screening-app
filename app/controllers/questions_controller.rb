class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  helper_method :sort_column, :sort_direction
  
  def index
    query = ''
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' lower(content) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @questions = Question.where(query, searchparam).paginate(page: params[:page], per_page: 10)
    @select_mode = false
    @searched = query != ''
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "Question created!"
      redirect_to root_url
    else
      @candidates = current_user.candidates
      render 'static_pages/home'
    end
  end

  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  def show
    @question = Question.find(params[:id])
  end

  def clone_question
    @question = Question.find(params[:id])
    @clone_question = Question.new
    @clone_question.content = @question.content
    @clone_question.answer = @question.answer
    @clone_question.difficulty_id = @question.difficulty_id
    @clone_question.category_id = @question.category_id
    @clone_question.user = current_user
    @clone_question.save
    flash[:success] = "Question cloned."
    redirect_to @clone_question
  end
  
  def destroy
    @question.destroy
    flash[:success] = "Question deleted."
    redirect_to request.referrer || root_url
  end

  private

    def question_params
      params.require(:question).permit(:difficulty_id, :category_id, :content, :answer)
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
