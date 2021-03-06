class TestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy, :show, :index]
  before_action :correct_user,   only: [:destroy, :edit, :update]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Tests", :tests_path

  def index
    only_mine = params[:only_my_tests]
    @single_test_select = params[:single_test_select]
    
    if !@single_test_select.blank?
      @candidate = Candidate.find(params[:id])
    end

    if only_mine.blank?
      query = ' (is_public = ? OR user_id = ?) '
      searchparam = ""
      if !params[:search].blank?
          query += ' AND (lower(name) LIKE ? OR lower(description) LIKE ?) '
          searchparam = "%#{params[:search].downcase}%"
        @tests = Test.where(query, true, current_user, searchparam, searchparam).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
      else
        @tests = Test.where(query, true, current_user).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
      end
    else 
      query = ' user_id = ? '
      searchparam = ""
      if !params[:search].blank?
          query += ' AND (lower(name) LIKE ? OR lower(description) LIKE ?) '
          searchparam = "%#{params[:search].downcase}%"
        @tests = Test.where(query, current_user, searchparam, searchparam).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
      else
        @tests = Test.where(query, current_user).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
      end
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
      @questions = Question.where(query, @test.id, searchparam).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    else
      @questions = Question.where(query, @test.id).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    end

    if !params[:category].blank?
      found_cat = Category.where("name = ?", params[:category])
      if found_cat.any?
        params[:category_id] = found_cat.first.id
      else
        params[:category_id] = "0"
      end
      @questions = @questions.where("category_id = ?", params[:category_id])
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
    @categories = Category.all
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
      redirect_to tests_path
    else
      if current_user.membership_level_id == 1 && current_user.tests.any? && 
        current_user.tests.count > Limits::MAX_TESTS_FREE
        flash[:info] = "Limit for number of tests for free membership level is: " + Limits::MAX_TESTS_FREE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 2 && current_user.tests.any? && 
        current_user.tests.count > Limits::MAX_TESTS_BRONZE
        flash[:info] = "Limit for number of tests for Bronze membership level is: " + Limits::MAX_TESTS_BRONZE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 3 && current_user.tests.any? && 
        current_user.tests.count > Limits::MAX_TESTS_GOLD
        flash[:info] = "Limit for number of tests for Gold membership level is: " + Limits::MAX_TESTS_GOLD.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 4 && current_user.tests.any? && 
        current_user.tests.count > Limits::MAX_TESTS_PLATINUM
        flash[:info] = "Limit for number of tests for Platinum membership level is: " + Limits::MAX_TESTS_PLATINUM.to_s + 
        ". Contact us to increase your limit!"
        redirect_to plans_path
      else

        @test = current_user.tests.build(test_params)
        if Test.where("name = ? and user_id = ?", @test.name, current_user.id).count > 0
          flash.now[:warning] = "You already have a test named " + @test.name + ". Please rename."
          render 'new'
        else
          if @test.save
            flash[:success] = "Test created!"
            if params[:commit] == "Save And Add Random Questions"
              redirect_to select_random_questions_path(id: @test.id)
            else
              redirect_to select_questions_path(id: @test.id)
            end 
          else
            render 'new'
          end
        end
      end
    end
  end

  def clone_test 
    @test = Test.find(params[:id])
    @clone_test = Test.new
    @clone_test.name = @test.name + " - CLONE"
    @clone_test.description = @test.description
    @clone_test.user = current_user
    @clone_test.is_public = false
    flash.now[:success] = "Test cloned. You can change any details you'd like."

    @test = @clone_test
    add_breadcrumb "Cloned Test", new_test_path
    render 'new'
  end

  def update
    @test = Test.find(params[:id])
    if params[:commit] == "Cancel"
      redirect_to @test
    else
      respond_to do |format|
        if @test.update_attributes(test_params)
          format.html { 
            flash[:success] = "Test was successfully updated."
            
            if params[:commit] == "Save And Modify Questions"
              redirect_to select_questions_path(id: @test.id)
            else
              redirect_to @test
            end
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
    
    if (params[:commit] == "Add Questions And Search Again")
      redirect_to select_questions_path(id: @test.id)
    else
      redirect_to @test
    end
  end

  def submit_random_questions
    @test = Test.find(params[:id])
    topic_list = params[:topic_list].split(",").map(&:strip)
    num_per_topic = params[:num_per_topic]
    if topic_list != nil
      topic_list.each do |topic|
        if topic == nil
          next
        end
        
        difficulty = nil
        if (params[:difficulty_level_1] == "1")
          difficulty = "1"
        end
        if (params[:difficulty_level_2] == "2")
          if difficulty == nil 
            difficulty = "2"
          else
            difficulty = difficulty + ", 2"
          end
        end
        if (params[:difficulty_level_3] == "3")
          if difficulty == nil 
            difficulty = "3"
          else
            difficulty = difficulty + ", 3"
          end
        end
        
        # first try exact name, then if no results, try partial:
        category = Category.where("lower(name) = '" + topic.downcase + "'")
        
        if category == nil
          category = Category.where("lower(name) like '%" + topic.downcase + "%'")
        end
      
        if category != nil && category.any?
          cat_questions = Question.where("category_id = " + category.first.id.to_s)
          if difficulty != nil
            cat_questions = cat_questions.where("difficulty_id IN (" + difficulty + ")")
          end
          
          if cat_questions.size < num_per_topic.to_i
            flash[:warning] = "Could not find enough existing questions for the topic: " + category.first.name + "."
            redirect_to request.referrer
            return
          else     
            cat_questions = cat_questions.shuffle
            (1..num_per_topic.to_i).each do |index|
              random_question = cat_questions [index - 1]
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
    
    if current_user != nil
      @test_results = @test.test_submissions.where("user_id = ?", current_user.id).paginate(page: params[:page]).order(sort_column + " " + sort_direction)
    end
    
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
      :difficulty_level, :num_per_topic, :created_at, :difficulty_level_1, :difficulty_level_2, 
      :difficulty_level_3, :only_my_tests)
    end
    
    def correct_user
      @test = current_user.tests.find_by(id: params[:id])
      redirect_to root_url if @test.nil?
    end
  
    def sort_column
      (Question.column_names.include?(params[:sort]) || Test.column_names.include?(params[:sort])) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

