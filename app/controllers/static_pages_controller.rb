class StaticPagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def home
    if logged_in?
      @question = current_user.questions.build
      @tests = current_user.tests.paginate(page: params[:page])
      @candidates = current_user.candidates.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
      @num_test_results = 0 #current_user.candidates.test_submissions.count
      @num_sent_tests = 0
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
  
  def sort_column
    Candidate.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
    
end
