class NotesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update, :show, :index]
  before_action :correct_user,   only: [:edit, :update, :show, :index]
  
  helper_method :sort_column, :sort_direction
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb "Notes", :notes_path

  def index
    query = ''
    searchparam = ""
    if !params[:search].blank?
      query += ' lower(content) LIKE ? '
      searchparam = "%#{params[:search].downcase}%"
    end

    @notes = Note.where(query, searchparam).paginate(page: params[:page], per_page: 10).order(sort_column + " " + sort_direction)

    @searched = query != ''
  end

  def create
    @candidate = Candidate.find(params[:note][:candidate_id])
    if params[:commit] == "Cancel"
      redirect_to @candidate
    else
      @candidate.notes.build(note_params)
      if @candidate.save
        flash[:success] = "Note added."
        redirect_to @candidate 
      else
        render 'new'
      end 
    end 
  end 

  def destroy
    @note = Note.find(params[:id])
    @candidate = @note.candidate 
    if @candidate.user != current_user
      redirect_to root_url 
    else
      @note.destroy
      flash[:success] = "Note deleted."
      redirect_to @candidate 
    end 
  end
  
  private  
    def note_params
      params.require(:note).permit(:id, :content, :candidate_id)
    end 
    
    def correct_user
      @candidate = current_user.candidates.find_by(id: params[:candidate_id])
      redirect_to root_url if @candiate.nil?
    end
  
    def sort_column
      Note.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
