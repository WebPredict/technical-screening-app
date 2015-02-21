class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      @feed_items = Micropost.paginate(page: params[:page], per_page: 5)
    end
  end

  def submitcontact
    UserMailer.contact_admin(params[:email], params[:comment]).deliver
    flash[:success] = "Thanks for your feedback... we will review it soon and meditate on it."
    redirect_to root_path
  end
  
  def help
  end
  
  def about
  end

  def contact
  end 
  
end
