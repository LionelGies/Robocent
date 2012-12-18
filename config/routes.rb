Robocent::Application.routes.draw do
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
  get   'twilionumbers/:code'        => 'users#twilionumbers', :as => :twilionumbers
  put   'register'                 => 'users#create',     :as => :register_user
  post  'register'                 => 'users#create',     :as => :register_user
  get   'register'                 => 'users#new',          :as => :register
  match 'register/activate/:token' => 'users#activate',     :as => :activate
  match 'register/confirmation'    => 'users#confirmation', :as => :register_confirmation

  resources :users

  #
  # public pages
  #
  match "terms"     => "public#terms",      :as => "terms"
  match "contact-us"   => "public#contact",    :as => "contact_us"
  match "guide"     => "public#guide",      :as => "guide"
  match "tutorials" => "public#tutorials",  :as => "tutorials"
  match "faq"       => "public#faq",        :as => "faq"
  match "support"   => "public#support",    :as => "support"
  match "pricing"   => "public#pricing",    :as => "pricing"
  match 'solutions' => "public#solutions",  :as => "solutions"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'public#index'

  # See how all your routes lay out with "rake routes"
end
