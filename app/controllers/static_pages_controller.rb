class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @question = current_user.questions.build
      @tests = current_user.tests.paginate(page: params[:page])
      @candidates = current_user.candidates
    else
      @questions = Question.paginate(page: params[:page], per_page: 5)
    end
  end

  def submitcontact
    UserMailer.contact_admin(params[:email], params[:comment]).deliver
    flash[:success] = "Thanks for your feedback... we will review it soon."
    redirect_to root_path
  end
  
  def help
  end
  
  def about
  end

  def contact
  end 
  
end
