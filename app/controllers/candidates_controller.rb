class CandidatesController < ApplicationController
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

    @feed_items = Candidate.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    @candidate = current_user.candidates.build(candidate_params)
    if @candidate.save
      flash[:success] = "Candidate created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def update
    @candidate = TestTaker.find(params[:id])
    respond_to do |format|
      if @candidate.update_attributes(candidate_params)
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
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
    @candidate_items = @candidate.items.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
  end

  def destroy
    @candidate.destroy
    flash[:success] = "Candidate deleted."
    redirect_to request.referrer || root_url
  end

  private

    def candidate_params
      params.require(:candidate).permit(:name)
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

