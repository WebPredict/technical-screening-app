class CategoriesController < ApplicationController
  before_action :logged_in_user, only: [:show]
  before_action :admin_user,   only: [:create, :edit, :update, :show, :edit_by_name]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Categories", :candidates_path

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @categories = Category.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to all_categories_path
    else 
      @category = Category.new(category_params)
      if @category.save
        flash[:success] = "Category " + @category.name + " created!"
        
          redirect_to all_categories_path
      else
        render 'new'
      end
    end
  end

  def autocomplete
    @categories = Category.order(:name).where("lower(name) like ?", "%#{params[:term].downcase}%")
    respond_to do |format|
      format.html
      format.json { 
        render json: @categories.map(&:name)
      }
    end
  end
  
  def update
    if params[:commit] == "Cancel"
      redirect_to all_categories_path
    else 
      @category = Category.find(params[:id])
      respond_to do |format|
        if @category.update_attributes(category_params)
          format.html { 
            flash[:success] = "Category was successfully updated."
            redirect_to @category
          }
          format.json { render :show, status: :ok, location: @category }
        else
          format.html { render :edit }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
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

  def edit_by_name
    if !params[:name].blank?
      @category = Category.where('name = ?', params[:name]).first
    else
      @category = Category.find(params[:id])
    end
    render 'edit'
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
      params.require(:category).permit(:name, :term)
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

