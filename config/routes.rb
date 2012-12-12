Robocent::Application.routes.draw do

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
  match "contact"   => "public#contact",    :as => "contact"
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
