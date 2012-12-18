class PublicController < ApplicationController
  def index
    redirect_to dashboard_path if current_user.present?
  end

  def solutions
  end

  def pricing
  end

  def support
  end

  def faq
  end

  def tutorials
  end

  def guide
  end

  def contact
  end

  def terms
  end
end
