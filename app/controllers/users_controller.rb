class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers, :metrics]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy
                  
                  
  add_breadcrumb "Dashboard", :root_path
                      
  # GET /users
  # GET /users.json
  def index
    query = ''
    searchparam = ""
    if params[:search] && params[:search] != ''
        query += ' lower(name) LIKE ?'
        searchparam = "%#{params[:search].downcase}%"
    end

    @users = User.where(query, searchparam).paginate(page: params[:page])
    @searched = query != ''
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @tests = @user.tests.paginate(page: params[:page])
    add_breadcrumb "Show Profile", :user_path
  end

  # GET /users/new
  def new
    @user = User.new
    @user.membership_level_id = params[:membership_level_id]
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    add_breadcrumb "Edit Profile", :edit_user_path
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      @user.send_activation_email
      
      if params[:user][:membership_level_id] == "1"
        flash[:info] = "Please check your email to activate your account."
        redirect_to root_url
      elsif params[:user][:membership_level_id] == "2"
        redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/g7zjvxxj/bronze", 
          {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
      elsif params[:user][:membership_level_id] == "3"
        redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/vryykwj4/gold", 
          {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
      elsif params[:user][:membership_level_id] == "4"
        redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/zhksdhbm/platinum", 
          {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
      end
      
    else
      render 'new'
    end
  end

  def edit_subscription
    @user = User.find(params[:id])
    if @user.membership_level.id == 1
      flash[:info] = "You've only signed up for the free version."
      redirect_to root_url
    elsif @user.membership_level.id == 2
      redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/g7zjvxxj/bronze", 
        {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
    elsif @user.membership_level.id == 3
      redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/vryykwj4/gold", 
        {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
    elsif @user.membership_level.id == 4
      redirect_to generate_url("https://techscreen-net.chargify.com/subscribe/zhksdhbm/platinum", 
        {reference: "4RKzhs3YJMNAAV2v7Zo" + @user.id.to_s})
    end
  end
  
  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end

  def metrics
    add_breadcrumb "Metrics", :metrics_path
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:commit] == "Cancel"
      redirect_to root_url
    else
      respond_to do |format|
        if @user.update_attributes(user_params)
          format.html { 
            flash[:success] = "User was successfully updated."
            redirect_to @user
          }
          format.json { render :show, status: :ok, location: @user }
        else
          render 'edit'
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted :("
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :membership_level_id,
                                   :password_confirmation, :company_ids)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
