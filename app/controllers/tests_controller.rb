class TestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Tests", :tests_path

  def index
    query = ' (is_public = ? OR user_id = ? ) '
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' AND lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
      @tests = Test.where(query, true, current_user, searchparam).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    else
      @tests = Test.where(query, true, current_user).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    end

    @searched = query != ''
  end

  def select_questions
    @test = Test.find(params[:id])
    @test_questions = @test.questions.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
    searchparam = ""
    question_ids = "SELECT question_id FROM questions_tests WHERE test_id = ?"
    query = "id NOT IN (#{question_ids})"

    if params[:search] && params[:search] != ''
        query += ' AND lower(content) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
      @questions = Question.where(query, @test.id, searchparam).paginate(page: params[:page], per_page: 10)
    else
      @questions = Question.where(query, @test.id).paginate(page: params[:page], per_page: 10)
    end

    @select_mode = true
    @searched = query != ''
    add_breadcrumb "Select Questions", :select_questions_path
  end
  
  def send_candidate_test
    @candidate = Candidate.find(params[:id])
    flash[:info] = "Select Test To Send To: " + @candidate.name
    @single_test_select = true
    @tests = Test.all.paginate(page: params[:page], per_page: 10)
    render 'index'
  end
  
  def select_test
    @candidate = Candidate.find(params[:id])
    @tests = Test.find(params[:test_ids])
    
    if @tests.any?
      @candidate.send_test(@tests.first)
      flash[:success] = "Test sent to candidate " + @candidate.name + "."
      redirect_to root_url
    else
      flash[:info] = "Please select a test to send."
      render 'index'
    end
  end
  
  def create
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      @test = current_user.tests.build(test_params)
      if @test.save
        flash[:success] = "Test created!"
        redirect_to select_questions_path(id: @test.id)
      else
        render 'edit'
      end
    end
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      @test = Test.find(params[:id])
      respond_to do |format|
        if @test.update_attributes(test_params)
          format.html { 
            flash[:success] = "Test was successfully updated."
            redirect_to @test 
          }
          format.json { render :show, status: :ok, location: @test }
        else
          format.html { render :edit }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def submit_questions 
    @questions = Question.find(params[:question_ids])
    if @questions.any?
      @test = Test.find(params[:id])
      @questions.each do |question|
        @test.questions << question
      end
      @test.save
    end
    flash[:success] = "Test questions added."
    redirect_to @test
  end

  def update_questions 
    @questions = Question.find(params[:question_ids])
    @test = Test.find(params[:id])
    @test.questions = @questions 
    @test.save
    flash[:success] = "Test updated."
    redirect_to @test
  end
  
  def new
    @test = Test.new
    @select_mode = true
    add_breadcrumb "New Test", :new_test_path
  end
  
  def sent
    # TODO
  end
  
  def results
    # TODO
  end

  # GET /tests/1/edit
  def edit
    @test = Test.find(params[:id])
    add_breadcrumb "Edit Test", :edit_test_path
  end

  def show
    @test = Test.find(params[:id])
    @test_questions = @test.questions.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
    add_breadcrumb "Show Test", :test_path
  end

  def destroy
    @test.destroy
    flash[:success] = "Test deleted."
    redirect_to request.referrer || root_url
  end

  private

    def test_params
      params.require(:test).permit(:name, :description, :question_ids, :is_public)
    end
    
    def correct_user
      @test = current_user.tests.find_by(id: params[:id])
      redirect_to root_url if @test.nil?
    end
  
    def sort_column
      Test.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

