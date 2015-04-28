class CandidatesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :show]
  before_action :correct_user,   only: [:destroy, :edit, :update, :show]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Candidates", :candidates_path

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @candidates = current_user.candidates
    
    if @candidates == nil || !@candidates.any?
      flash.now[:info] = "Create a candidate entry to represent a job applicant, which may then perform screening tests. " + 
        "The test results may then be forwarded to employers."
    end

    if @candidates != nil
      @candidates = @candidates.where(query, searchparam).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)
    end
  
    @searched = query != ''
  end

  def filter_candidates
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @candidates = current_user.candidates
    
    if @candidates != nil
      @candidates = @candidates.where(query, searchparam).paginate(page: params[:page], per_page: 10)
    end

    @searched = query != ''
  end

  def send_candidate_test
    @test = Test.find(params[:id])
    flash.now[:info] = "Select an existing candidate to send test '" + @test.name + "':"
    @single_candidate_select = true
    
    @candidates = current_user.candidates
    
    if @candidates != nil
      @candidates = @candidates.paginate(page: params[:page], per_page: 10)
    end
 
    render 'send_test'
  end
  
  def select_candidate
    @test = Test.find(params[:id])
    @candidates = Candidate.find(params[:candidate_ids])
    
    if @candidates.any?
      @candidates.first.send_test(@test, current_user.email)
      flash[:success] = "Test sent to candidate " + @candidates.first.name + "."
      redirect_to root_url
    else
      flash[:info] = "Please select a test to send."
      render 'send_test'
    end
  end

  def create
    if params[:commit] == "Cancel"
      redirect_to root_url
    else 
      if current_user.membership_level_id == 1 && current_user.candidates.any? && 
        current_user.candidates.count > Limits::MAX_CANDIDATES_FREE
        flash[:info] = "Limit for number of candidates for free membership level is: " + Limits::MAX_CANDIDATES_FREE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 2 && current_user.candidates.any? && 
        current_user.candidates.count > Limits::MAX_CANDIDATES_BRONZE
        flash[:info] = "Limit for number of candidates for Bronze membership level is: " + Limits::MAX_CANDIDATES_BRONZE.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 3 && current_user.candidates.any? && 
        current_user.candidates.count > Limits::MAX_CANDIDATES_GOLD
        flash[:info] = "Limit for number of candidates for Gold membership level is: " + Limits::MAX_CANDIDATES_GOLD.to_s + ". Upgrade now to increase your limit!"
        redirect_to plans_path
      elsif current_user.membership_level_id == 4 && current_user.candidates.any? && 
        current_user.candidates.count > Limits::MAX_CANDIDATES_PLATINUM
        flash[:info] = "Limit for number of candidates for Platinum membership level is: " + Limits::MAX_CANDIDATES_PLATINUM.to_s + 
        ". Contact us to increase your limit!"
        redirect_to plans_path
      else
        @candidate = current_user.candidates.build(candidate_params)
        if @candidate.save
          flash[:success] = "Candidate created!"
          if params[:job_id] != '' && params[:job_id] != nil
            @job = Job.find(params[:job_id])
            if @job != nil
              @job.candidates << @candidate 
              @job.save 
            end
          end 
          
          if params[:commit] == "Save And Send Test"
            flash[:info] = "Select test to send to candidate:"
            @single_test_select = true
            redirect_to tests_path
          else 
            redirect_to @candidate 
          end
        else
          render 'new'
        end
      end
    end
  end

  def update
    @candidate = Candidate.find(params[:id])
    respond_to do |format|
      if @candidate.update_attributes(candidate_params)
        format.html { 
            flash[:success] = "Candidate was successfully updated."
            redirect_to @candidate 
          }
        format.json { render :show, status: :ok, location: @candidate }
      else
        format.html { render :edit }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    @candidate = Candidate.new
    @job_id = ''
    if params[:job_id] != '' && params[:job_id] != nil
      @job = Job.find(params[:job_id])
      if @job != nil
        @candidate.job_title = @job.name
        @job_id = @job.id
      end
    end

    add_breadcrumb "New Candidate", new_candidate_path
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
  end

  def show
    @candidate = Candidate.find(params[:id])
    @candidate_test_submissions = @candidate.test_submissions.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
  end

  def destroy
    @candidate.destroy
    flash[:success] = "Candidate deleted."
    redirect_to candidates_path
  end

  private

    def candidate_params
      params.require(:candidate).permit(:name, :phone, :email, :job_title, :job_id)
    end
    
    def correct_user
      @candidate = current_user.candidates.find_by(id: params[:id])
      redirect_to root_url if @candidate.nil?
    end
  
    def sort_column
      Candidate.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

