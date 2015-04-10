class CategoriesController < ApplicationController
  before_action :logged_in_user, only: [:show]
  before_action :admin_user,   only: [:create, :edit, :update, :show]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Categories", :candidates_path

  def index
    query = ''
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @candidates = Category.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to root_url
    else 
      @candidate = current_user.candidates.build(candidate_params)
      if @candidate.save
        flash[:success] = "Candidate created!"
        
        if params[:commit] == "Save And Send Test"
          flash[:info] = "Select test to send to candidate:"
          @single_test_select = true
          redirect_to tests_path
        else 
          redirect_to root_url
        end
      else
        render 'new'
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update_attributes(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  def show
    @category = Category.find(params[:id])
  end

  def destroy
    @category.destroy
    flash[:success] = "Category deleted."
    redirect_to request.referrer || root_url
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
    
    def admin_user
      redirect_to root_url if current_user.admin? == false
    end
  
    def sort_column
      Category.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

