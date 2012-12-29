Robocent::Application.routes.draw do

  put "migrate"             => "subscriptions#migrate",   :as => :migrate
  match "migration"         => "subscriptions#migration", :as => :migration

  post 'stripe-webhook'       => 'stripe_webhook#create'

  put   'update-billing/:id'  => 'billing#update',       :as => :update_billing
  match 'edit-billing/:id'    => 'billing#edit',         :as => :edit_billing
  post  'fund-account'        => 'billing#fund_account', :as => :fund_account
  match 'billing'             => 'billing#index',        :as => :billing

  resources :imports do
    collection do
      get :save_s3_file_path
    end
    member do
      get :map_column
      post :insert_into_db
    end
  end

  resources :contacts

  resources :lists

  #
  # Dashboard
  #
  match 'dashboard'             => 'dashboard#index',             :as => :dashboard

  #
  # user sessions
  #
  match 'login'                 => 'user_sessions#new',           :as => :login
  match 'logout'                => 'user_sessions#destroy',       :as => :logout

  resources :user_sessions

  #
  # registration
  #
  get   'twilionumbers/:code'      => 'users#twilionumbers',  :as => :twilionumbers
  put   'register'                 => 'users#create',         :as => :register_user
  post  'register'                 => 'users#create',         :as => :register_user
  get   'register'                 => 'users#new',            :as => :register
  match 'register/activate/:token' => 'users#activate',       :as => :activate
  match 'register/confirmation'    => 'users#confirmation',   :as => :register_confirmation

  resources :users

  #
  # public pages
  #
  match "terms"       => "publics#terms",      :as => "terms"
  match "contact-us"  => "publics#contact",    :as => "contact_us"
  match "guide"       => "publics#guide",      :as => "guide"
  match "tutorials"   => "publics#tutorials",  :as => "tutorials"
  match "faq"         => "publics#faq",        :as => "faq"
  match "support"     => "publics#support",    :as => "support"
  match "pricing"     => "publics#pricing",    :as => "pricing"
  match 'solutions'   => "publics#solutions",  :as => "solutions"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'publics#index'

  # See how all your routes lay out with "rake routes"
end
