class CandidatesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :show]
  before_action :correct_user,   only: [:destroy, :edit, :update, :show]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Candidates", :candidates_path

  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @candidates = Candidate.where(query, searchparam).paginate(page: params[:page], per_page: 10)

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
          redirect_to @candidate 
        end
      else
        render 'new'
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
    redirect_to request.referrer || root_url
  end

  private

    def candidate_params
      params.require(:candidate).permit(:name, :phone, :email, :job_title)
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

