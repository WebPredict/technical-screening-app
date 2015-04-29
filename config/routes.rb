Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root 'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'all_categories'   => 'static_pages#all_categories'
  get 'contact' => 'static_pages#contact'
  get 'plans' => 'memberships#plans'
  get 'bronze' => 'memberships#bronze'
  get 'gold' => 'memberships#gold'
  get 'platinum' => 'memberships#platinum'
  get 'subscribe' => 'memberships#subscribe'
  get 'edit_subscription' => 'users#edit_subscription'

  get 'make_easy' => 'questions#make_easy'
  get 'make_medium' => 'questions#make_medium'
  get 'make_hard' => 'questions#make_hard'
  
  get 'news' => 'static_pages#news'
  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  post  'submitcontact' => 'static_pages#submitcontact'
  delete 'logout'  => 'sessions#destroy'
  
  get 'select_questions' => 'tests#select_questions'
  get 'select_random_questions' => 'tests#select_random_questions'
  post 'update_questions' => 'tests#update_questions'
  post 'submit_questions' => 'tests#submit_questions'
  post 'submit_random_questions' => 'tests#submit_random_questions'
  get 'send_candidate_test' => 'tests#send_candidate_test'
  get 'send_test_candidate' => 'candidates#send_candidate_test'
  get 'clone_question' => 'questions#clone_question'
  get 'clone_test' => 'tests#clone_test'
  get 'test_results' => 'tests#results'
  get 'sent_tests' => 'tests#sent'
  get 'start_test' => 'test_submissions#start_test'
  post 'select_test' => 'tests#select_test'
  get 'score_test' => 'test_submissions#score_test'
  post 'submit_score_test' => 'test_submissions#submit_score_test'
  get 'candidate_submissions' => 'test_submissions#candidate_submissions'
  post 'submit_forward_submission' => 'test_submissions#submit_forward_submission'
  get 'forward_submission' => 'test_submissions#forward_submission'
  post 'auto_score_test' => 'test_submissions#auto_score'
  get 'company_jobs' => 'companies#jobs'
  get 'metrics' => 'users#metrics'
  post 'select_candidate' => 'candidates#select_candidate'
  post 'filter_candidates' => 'candidates#filter_candidates'
  
  resources :companies

  resources :categories 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  resources :jobs
  
  resources :tests do 
    resources :questions
  end

  resources :candidates
  resources :test_submissions
  resources :questions
  resources :users 
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
