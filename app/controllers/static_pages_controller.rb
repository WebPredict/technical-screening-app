class StaticPagesController < ApplicationController
  helper_method :sort_column, :sort_direction

  add_breadcrumb "Home", :root_path

  def home
    if logged_in?
      
      show_all = false
      if params[:show_all] == 'true'
        session[:show_all] = true
        show_all = true
      elsif params[:show_all] == 'false'
        session[:show_all] = true
      elsif session[:show_all] != nil
        show_all = session[:show_all]
      end
      
      @question = current_user.questions.build
      @tests = current_user.tests.paginate(page: params[:page])
      @companies = current_user.companies.paginate(page: params[:page])
      
      @num_tests = current_user.tests.count
      
      if show_all
        @show_all = true
        @candidates = current_user.candidates.paginate(page: params[:page]).order("avg_score desc")
      else
        @candidates = current_user.candidates.paginate(page: params[:page]).order(sort_column + " " + sort_direction)
        @show_all = false
      end
      
      # TODO: this needs its own pagination param!
      @test_submissions = TestSubmission.where("user_id = ?", current_user.id).paginate(page: params[:page])
      
      @num_test_results = 0
      
      # TODO this needs its own pagination param!
      @jobs = Job.where("user_id = ?", current_user.id).paginate(page: params[:page])
      
      if current_user.candidates.any?
        current_user.candidates.each do |candidate|
          if candidate.test_submissions.any?
            @num_test_results += candidate.test_submissions.count
          end
        end
        
      end
      
      if current_user.candidates.any?
        @num_candidates = current_user.candidates.count
      else
        @num_candidates = 0
      end
    else
      @categories = Category.all 
      @categories_arrays = @categories.each_slice(@categories.count / 3).to_a
      @categories_first = @categories_arrays [0]
      @categories_second = @categories_arrays [1]
      @categories_third = @categories_arrays [2]
    end
  end

  def submitcontact
    UserMailer.contact_admin(params[:email], params[:comment], params[:subject]).deliver
    flash[:success] = "Thanks for your feedback... we will review it soon."
    redirect_to root_path
  end
  
  def help
    add_breadcrumb "Help", :root_path
  end
  
  def about
    @categories = Category.all 
    @categories_arrays = @categories.each_slice(@categories.count / 3).to_a
    @categories_first = @categories_arrays [0]
    @categories_second = @categories_arrays [1]
    @categories_third = @categories_arrays [2]

    add_breadcrumb "About", :root_path
  end

  def all_categories
    @categories = Category.all 
    @categories_arrays = @categories.each_slice(@categories.count / 3).to_a
    @categories_first = @categories_arrays [0]
    @categories_second = @categories_arrays [1]
    @categories_third = @categories_arrays [2]

    add_breadcrumb "Available Categories", :root_path
  end

  def contact
    add_breadcrumb "Contact", :contact_path
  end 
  
  def sort_column
    Candidate.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
    
end
