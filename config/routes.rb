Robocent::Application.routes.draw do

  post "welcome-pop-up-submit" => 'dashboard#welcome_pop_up_submit', :as => :welcome_pop_up_submit

  resources :dnc, :only => [:index, :create, :destroy]

  match 'inbox-support'       => 'support#inbox',       :as => :inbox_support
  match 'send-a-call-support' => 'support#send_a_call', :as => :send_a_call_support
  match 'send-a-text-support' => 'support#send_a_text', :as => :send_a_text_support
  match 'dashboard-support'   => 'support#contacts',    :as => :contacts_support
  match 'support'             => 'support#index',       :as => :dashboard_support

  resources :password_resets, :except => [:index, :destroy]

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match "find-new-recording" => 'recordings#find_new_recording'
  match "replay"          => 'recordings#replay', :as => :replay
  match "save-or-record"  => 'recordings#save_or_record', :as => :save_or_record

  resources :incoming_calls

  resources :recordings do
    member do
      get :play
    end
  end

  match 'send-call'      => 'calls#new',            :as => :send_call
  match 'send-test-call' => 'calls#send_test_call', :as => :send_test_call

  resources :calls

  post "notifications/adaptive_ipn" => "notifications#adaptive_ipn"

  get "inbox"   => "sms_messages#inbox", :as => :inbox
  get "inbox-read" => "sms_messages#inbox_read"
  get "start-conversation" => 'sms_messages#start_conversation', :as => :start_conversation

  resources :sms_messages

  resources :text_messages, :only => [:show, :create] do
    member do
      get :send_text_succeeded_numbers
      get :send_text_errors
    end
  end

  #
  # Text
  #
  match 'send-a-test'         => 'text_messages#send_a_test', :as => :send_a_test
  match 'send-text'           => 'text_messages#new',         :as => :send_text

  put   "migrate"             => "subscriptions#migrate",   :as => :migrate
  match "migration"           => "subscriptions#migration", :as => :migration

  post 'stripe-webhook'       => 'stripe_webhook#create'

  put   'update-billing/:id'  => 'billing#update',       :as => :update_billing
  match 'edit-billing/:id'    => 'billing#edit',         :as => :edit_billing
  post  'fund-account'        => 'billing#fund_account', :as => :fund_account
  get   'billing'             => 'billing#index',           :as => :billing
  post  'billing'             => 'billing#create',          :as => :create_billing

  resources :imports do
    collection do
      get :save_s3_file_path
    end
    member do
      get :map_column
      match :insert_into_db
    end
  end

  resources :contacts

  resources :lists do
    member do
      get :export_contacts
    end
    collection do
      match :check_validation
    end
  end

  #
  # Dashboard
  #
  match 'profile'               => 'dashboard#profile',           :as => :profile
  match 'dashboard'             => 'dashboard#index',             :as => :dashboard

  #
  # user sessions
  #
  match 'login'                 => 'user_sessions#new',           :as => :login
  match 'logout'                => 'user_sessions#destroy',       :as => :logout

  resources :user_sessions, :only => [:create]

  #
  # registration
  #
  get   'twilionumbers/:code'      => 'users#twilionumbers',  :as => :twilionumbers
  match 'register/activate/:token' => 'users#activate',       :as => :activate

  put 'update-password'    => 'users#update_password',   :as => :update_password

  resources :users, :except => [:index, :show, :destroy]
  
  #
  # public pages
  #
  match "email-code"       => 'publics#email_code'
  match "email"       => 'publics#promo_email', :as => :promo_email
 
  match "smsterms"    => "publics#sms_terms", :as => :sms_terms
  match "smsprivacy"  => "publics#sms_privacy", :as => :sms_privacy
  match "terms"       => "publics#terms",      :as => "terms"
  match "privacy-policy" => "publics#privacy_policy", :as => :privacy_policy
  match 'contact-us-submit' => "publics#contact_us_submit" , :as => :contact_us_submit
  match "contact-us"  => "publics#contact",    :as => "contact_us"
  match 'solutions'   => "publics#solutions",  :as => "solutions"
  match 'residential_communities'   => "publics#residential_communities",  :as => "residential_communities"

  root :to => 'publics#index'
end
