class DashboardController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
  end
end
