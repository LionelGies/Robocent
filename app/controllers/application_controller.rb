class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_url, :alert => exception.message
  end

  helper_method :formatted_number

  def not_authenticated
    redirect_to login_url, :alert => "First login to access this page."
  end

  def formatted_number(number)
    number = number.to_s
    digits = number.gsub(/\D/, '').split(//)

    if (digits.length == 11 and digits[0] == '1')
      # Strip leading 1
      digits.shift
    end

    if (digits.length == 10)
      digits = '(%s) %s-%s' % [ digits[0,3].join, digits[3,3].join, digits[6,4].join ]
    else
      return false
    end
    return digits.to_s
  end

end
