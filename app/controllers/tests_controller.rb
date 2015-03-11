class TestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  helper_method :sort_column, :sort_direction
  
  def index
    query = ''
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @feed_items = Test.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    @test = current_user.tests.build(test_params)
    if @test.save
      flash[:success] = "Test created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def update
    @test = Test.find(params[:id])
    respond_to do |format|
      if @test.update_attributes(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def submit_questions 
    @questions = Question.find(params[:question_ids])
  end
  
  def select_questions 
  end
  
  def new
    @test = Test.new
    @select_mode = true
  end

  # GET /tests/1/edit
  def edit
    @test = Test.find(params[:id])
  end

  def show
    @test = Test.find(params[:id])
    @test_items = @test.items.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
  end

  def destroy
    @test.destroy
    flash[:success] = "Test deleted."
    redirect_to request.referrer || root_url
  end

  private

    def test_params
      params.require(:test).permit(:name)
    end
    
    def correct_user
      @test = current_user.tests.find_by(id: params[:id])
      redirect_to root_url if @test.nil?
    end
  
end

