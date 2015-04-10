class JobsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :show]
  before_action :correct_user,   only: [:destroy, :edit, :update, :show]
  
  helper_method :sort_column, :sort_direction

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Jobs", :jobs_path

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @jobs = Job.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def show
    @job = Job.find(params[:id])
    add_breadcrumb "Show Job Listing", job_path
  end

  def new
    @job = Job.new
    @companies = current_user.companies 
    add_breadcrumb "New Job Listing", new_job_path
  end

  def create
    @company = Company.find(params[:job][:company_id])
    
    @job = @company.jobs.build(job_params)
    @job.user_id = current_user.id
    if @job.save
      flash[:success] = "Job created!"
      redirect_to root_url
    else
      @companies = current_user.companies 
      render 'new'
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    @companies = current_user.companies 
    add_breadcrumb "Edit Job Listing", edit_job_path
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      @job = Job.find(params[:id])
      respond_to do |format|
        if @company.update_attributes(job_params)
          format.html { 
            flash[:success] = "Job was successfully updated."
            redirect_to @job 
          }
          format.json { render :show, status: :ok, location: @job }
        else
          format.html { render :edit }
          format.json { render json: @job.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @job.destroy
    flash[:success] = "Job deleted."
    redirect_to request.referrer || root_url
  end

  private

    def job_params
      params.require(:job).permit(:name, :description, :company_id, :manager, :phone)
    end
    
    def correct_user
      @job = Job.find_by(id: params[:id])
      redirect_to root_url if @job.nil? || current_user.id != @job.user_id 
    end
    
    def sort_column
      Job.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
