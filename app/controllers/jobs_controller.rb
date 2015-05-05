class JobsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :show]
  before_action :correct_user,   only: [:destroy, :edit, :update, :show]
  
  helper_method :sort_column, :sort_direction

  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Jobs", :jobs_path

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @jobs = Job.where("user_id = ?", current_user.id)
    
    if @jobs != nil
      @jobs = @jobs.paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    end
    
    if current_user.jobs == nil || !current_user.jobs.any?
      flash.now[:info] = "You can create a job listing for candidates to be associated with, and help keep track of what they've applied for."
    end

    @searched = query != ''
  end

  def show
    @job = Job.find(params[:id])
    @job_candidates = @job.candidates.paginate(page: params[:page]).order(sort_column + " " + sort_direction)

    add_breadcrumb "Show Job Listing", job_path
  end

  def new
    @job = Job.new
    if params[:company_id] != '' && params[:company_id] != nil
      @company = Company.find(params[:company_id])
      if @company != nil
        @job.company_id = @company.id
      end
    end
    
    @companies = current_user.companies 
    add_breadcrumb "New Job Listing", new_job_path
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to jobs_path
    else
      
      if current_user.membership_level_id == 1 && current_user.jobs.any? && 
        current_user.jobs.count > Limits::MAX_JOB_LISTINGS_FREE
        flash[:info] = "Limit for number of job listings for free membership level is: " + Limits::MAX_JOB_LISTINGS_FREE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 2 && current_user.jobs.any? && 
        current_user.jobs.count > Limits::MAX_JOB_LISTINGS_BRONZE
        flash[:info] = "Limit for number of job listings for Bronze membership level is: " + Limits::MAX_JOB_LISTINGS_BRONZE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 3 && current_user.jobs.any? && 
        current_user.jobs.count > Limits::MAX_JOB_LISTINGS_GOLD
        flash[:info] = "Limit for number of job listings for Gold membership level is: " + Limits::MAX_JOB_LISTINGS_GOLD.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 4 && current_user.jobs.any? && 
        current_user.jobs.count > Limits::MAX_JOB_LISTINGS_PLATINUM
        flash[:info] = "Limit for number of job listings for Platinum membership level is: " + Limits::MAX_JOB_LISTINGS_PLATINUM.to_s + 
        ". Contact us to increase your limit!"
        redirect_to plans_path
      else
      
        company_id = params[:job][:company_id]
        if company_id != nil && company_id != ''
          @company = Company.find(params[:job][:company_id])
          @job = @company.jobs.build(job_params)
        else
          @job = Job.new(job_params)
        end
        
        @job.user_id = current_user.id
        if @job.save
          flash[:success] = "Job created!"
          redirect_to @job
        else
          @companies = current_user.companies 
          render 'new'
        end
      end
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
      redirect_to jobs_path
    else
      @job = Job.find(params[:id])
      respond_to do |format|
        if @job.update_attributes(job_params)
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
    redirect_to jobs_path
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
