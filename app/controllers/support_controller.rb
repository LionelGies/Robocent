class SupportController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
  end

  def contacts
  end

  def send_a_text
  end

  def send_a_call
  end

  def inbox
  end
end