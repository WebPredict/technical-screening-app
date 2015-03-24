class TestSubmissionsController < ApplicationController
  #before_action :logged_in_user, only: [:create, :destroy]
  #before_action :correct_user,   only: :destroy
  
  helper_method :sort_column, :sort_direction
  
  def index
    query = ''
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @test_submissions = TestSubmission.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    if params[:id] != nil
      @candidate = Candidate.find(params[:id])
    else
      @candidate = Candidate.new 
      @candidate.name = current_user.name + " - test taker"
      @candidate.email = current_user.email
      @candidate.user = current_user
      @candidate.save
    end
    if @candidate
      @test_submission = @candidate.test_submissions.build(test_submission_params)
      @test_submission.user = current_user
      @test_submission.test = Test.find(params[:test_id])
      @test_submission.candidate = @candidate
      if @test_submission.save
        flash[:success] = "Test submission created!"
        redirect_to root_url
      else
        flash[:error] = "Test submission could not be saved."
        render 'edit'
      end
    else
      flash[:error] = "Test submission could not be saved because the candidate is missing."
      render 'edit'
    end
  end

  def score_test
    @test_submission = TestSubmission.find(params[:id])
  end
  
  def submit_score_test
    @test_submission = TestSubmission.find(params[:id])
  end
  
  def update
    @test_submission = TestSubmission.find(params[:id])
    respond_to do |format|
      if @test_submission.update_attributes(test_submission_params)
        format.html { redirect_to @test_submission, notice: 'Test submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_submission }
      else
        format.html { render :edit }
        format.json { render json: @test_submission.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    @test_submission = TestSubmission.new
    @test_submission.test = Test.find(params[:id])

    @test_submission.test.questions.each do |question|
      @test_submission.answered_questions.build(question_id: question.id)
    end
  end

  def start_test
    @test_submission = TestSubmission.new
    @test_submission.candidate = Candidate.find_by(params[:email])
    
    if @test_submission.candidate && @test_submission.candidate.valid_token?(params[:token])
      @test_submission.test = Test.find(params[:test_id])

      @test_submission.test.questions.each do |question|
        # testing
        @test_submission.answered_questions.build(question_id: question.id)
      end
      render 'new'
    else
      flash[:error] = "Invalid test token."
    end
  end

  # GET /test_submissions/1/edit
  def edit
    @test_submission = TestSubmission.find(params[:id])
  end

  def show
    @test_submission = TestSubmission.find(params[:id])
    #@test_submission_items = @test_submission.items.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
  end

  def destroy
    @test_submission.destroy
    flash[:success] = "Test submission deleted."
    redirect_to request.referrer || root_url
  end

  private

    def test_submission_params
      params.require(:test_submission).permit(:id, :name, :test_id, answered_questions_attributes: [:id, :question_id, :answer])
    end
    
    def correct_user
      @test_submission = current_user.test_submissions.find_by(id: params[:id])
      redirect_to root_url if @test_submission.nil?
    end
  
end

