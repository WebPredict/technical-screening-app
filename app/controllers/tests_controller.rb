class TestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Tests", :tests_path

  def index
    query = ' (is_public = ? OR user_id = ?) '
    searchparam = ""
    if !params[:search].blank?
        query += ' AND lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
      @tests = Test.where(query, true, current_user, searchparam)..order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @tests = Test.where(query, true, current_user).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    end

    if current_user != nil && (current_user.tests == nil || !current_user.tests.any?)
      flash.now[:info] = "You can create a screening test to send to a job candidate, or browse existing tests here. You can also clone and modify existing tests."
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
      @questions = Question.where(query, @test.id, searchparam).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    else
      @questions = Question.where(query, @test.id).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    end

    @select_mode = true
    @searched = query != ''
    add_breadcrumb "Select Questions", :select_questions_path
  end

  def select_random_questions
    @test = Test.find(params[:id])
    @test_questions = @test.questions.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
    add_breadcrumb "Select Random Questions", :select_random_questions_path
    flash.now[:info] = "Specify a list of topics to choose random questions from (e.g. \"Java, HTML, SQL\")."
  end
  
  def send_candidate_test
    @candidate = Candidate.find(params[:id])
    flash.now[:info] = "Select an existing screening test to send to candidate '" + @candidate.name + "':"
    @single_test_select = true
    @tests = Test.all.paginate(page: params[:page], per_page: 10)
    render 'index'
  end
  
  def select_test
    @candidate = Candidate.find(params[:id])
    @tests = Test.find(params[:test_ids])
    
    if @tests.any?
      @candidate.send_test(@tests.first, current_user.email)
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
        if params[:commit] == "Select Random Questions"
          redirect_to select_random_questions_path(id: @test.id)
        else
          redirect_to select_questions_path(id: @test.id)
        end 
      else
        render 'edit'
      end
    end
  end

  def clone_test 
    @test = Test.find(params[:id])
    @clone_test = Test.new
    @clone_test.name = @test.name
    @clone_test.description = @test.description
    @clone_test.user = current_user
    flash.now[:success] = "Test cloned. You can change any details you'd like."

    @test = @clone_test
    add_breadcrumb "Cloned Test", new_test_path
    render 'new'
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

  def submit_random_questions
    topic_list = params[:topic_list].split(",").map(&:strip)
    num_per_topic = params[:num_per_topic]
    if topic_list != nil
      @test = Test.find(params[:id])
      topic_list.each do |topic|
        if topic == nil
          next
        end
        
        difficulty = nil
        if (!params[:difficulty_level].blank?)
          difficulty = Difficulty.find(params[:difficulty_level])
        end
        
        # first try exact name, then if no results, try partial:
        category = Category.where("lower(name) = '" + topic.downcase + "'")
        
        if category == nil
          category = Category.where("lower(name) like '%" + topic.downcase + "%'")
        end
      
        if category != nil && category.any?
          cat_questions = Question.where("category_id = " + category.first.id.to_s)
          if difficulty != nil
            cat_questions = cat_questions.where("difficulty_id = " + difficulty.id.to_s)
          end
          
          if cat_questions.size < num_per_topic.to_i
            flash[:warning] = "Could not find enough existing questions for the topic: " + category.first.name + "."
            redirect_to request.referrer
            return
          else     
            cat_questions = cat_questions.shuffle
            (1..num_per_topic.to_i).each do |index|
              random_question = cat_questions [index]
                @test.questions << random_question
            end
          end
        else
          flash[:warning] = "Could not find any categories matching the topic: " + topic + "."
          redirect_to request.referrer
          return
        end
        
        @test.save 
      end
      
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
    if !@test.test_submissions.any?
      @test.destroy
      flash[:success] = "Test deleted."
      redirect_to tests_path
    else
      flash[:warning] = "Cannot delete this test because it has test results referencing it."
      redirect_to request.referrer
    end
  end

  private

    def test_params
      params.require(:test).permit(:name, :description, :question_ids, :is_public, :topic_list, 
      :difficulty_level, :num_per_topic, :created_at)
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

