Robocent::Application.routes.draw do

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
  match 'send-a-test'     => 'text_messages#send_a_test', :as => :send_a_test
  match 'send-text'       => 'text_messages#new',         :as => :send_text

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

  resources :lists do
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

  resources :user_sessions

  #
  # registration
  #
  #get   'twilionumbers/:code'      => 'users#twilionumbers',  :as => :twilionumbers
  #put   'register'                 => 'users#create',         :as => :register_user
  #post  'register'                 => 'users#create',         :as => :register_user
  #get   'register'                 => 'users#new',            :as => :register
  #match 'register/activate/:token' => 'users#activate',       :as => :activate
  #match 'register/confirmation'    => 'users#confirmation',   :as => :register_confirmation
  put 'update-password'    => 'users#update_password',   :as => :update_password
  #resources :users

  # for demo
  get   'twilionumbers/:code'      => 'users#twilionumbers',   :as => :twilionumbers
  put   'register2'                 => 'users#create',         :as => :register_user
  post  'register2'                 => 'users#create',         :as => :register_user
  get   'register2'                 => 'users#new',            :as => :register2
  match 'register2/activate/:token' => 'users#activate',       :as => :activate
  match 'register2/confirmation'    => 'users#confirmation',   :as => :register_confirmation
  get   'register'                 => 'temp_users#new',        :as => :register
  resources :users

  resources :temp_users, :only => [:new, :create]
  
  #
  # public pages
  #
  match 'contact-us-submit' => "publics#contact_us_submit" , :as => :contact_us_submit
  match "terms"       => "publics#terms",      :as => "terms"
  match "contact-us"  => "publics#contact",    :as => "contact_us"
  match "guide"       => "publics#guide",      :as => "guide"
  match "tutorials"   => "publics#tutorials",  :as => "tutorials"
  match "faq"         => "publics#faq",        :as => "faq"
  match "support"     => "publics#support",    :as => "support"
  match "pricing"     => "publics#pricing",    :as => "pricing"
  match 'solutions'   => "publics#solutions",  :as => "solutions"
  match "SMSTerms"    => "publics#sms_terms",   :as => "sms_terms"
  match "SMSPrivacy"  => "publics#sms_privacy", :as => "sms_privacy"
  match "smsterms"    => "publics#sms_terms", :as => :sms_terms
  match "smsprivacy"  => "publics#sms_privacy", :as => :sms_privacy

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'publics#index'

  # See how all your routes lay out with "rake routes"
end
