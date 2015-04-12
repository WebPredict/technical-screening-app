class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Companies", :companies_path

  helper_method :sort_column, :sort_direction

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @companies = current_user.companies
    
    if @companies != nil
      @companies = @companies.where(query, searchparam).paginate(page: params[:page], per_page: 10)
    end
    
    @searched = query != ''
  end

  def jobs
    @jobs = Company.find(:company_id).jobs
  end
  
  def new
    @company = Company.new
    add_breadcrumb "New Company", new_company_path
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to companies_path
    else
      @company = current_user.companies.build(company_params)
      @company.users << current_user
      if @company.save
        flash[:success] = "Company created!"
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def show
    @company = Company.find(params[:id])
    add_breadcrumb "Show Company", company_path
    @company_jobs = @company.jobs.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
  end
  
  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    add_breadcrumb "Edit Company", edit_company_path
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      @company = Company.find(params[:id])
      respond_to do |format|
        if @company.update_attributes(company_params)
          format.html { 
            flash[:success] = "Company was successfully updated."
            redirect_to @company 
          }
          format.json { render :show, status: :ok, location: @company }
        else
          format.html { render :edit }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if !@company.jobs.any?
      @company.destroy
      flash[:success] = "Company deleted."
      redirect_to request.referrer || root_url
    else
      flash[:warning] = "Cannot delete this company because it has jobs referencing it."
      redirect_to request.referrer
    end

  end

  private

    def company_params
      params.require(:company).permit(:name, :description, :email, :website, :address, :phone, :manager, :user_ids)
    end
    
    def correct_user
      @company = current_user.companies.find_by(id: params[:id])
      redirect_to root_url if @company.nil?
    end
    
    def sort_column
      Company.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
