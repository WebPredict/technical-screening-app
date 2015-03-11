class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    query = ''
    searchparam = ""
    paramarr = []
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ? '
        searchparam = "%#{params[:search].downcase}%"
    end

    @feed_items = Company.where(query, searchparam).paginate(page: params[:page], per_page: 10)

    @searched = query != ''
  end

  def create
    @company = current_user.companies.build(company_params)
    if @company.save
      flash[:success] = "Company created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @company.destroy
    flash[:success] = "Company deleted."
    redirect_to request.referrer || root_url
  end

  private

    def company_params
      params.require(:company).permit(:name)
    end
    
    def correct_user
      @company = current_user.companies.find_by(id: params[:id])
      redirect_to root_url if @company.nil?
    end
    
end
