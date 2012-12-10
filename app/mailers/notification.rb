class Notification < ActionMailer::Base

  # set global/default values for all mail types
  default :from => %|Robocent.com <welcome@robocent.com>|
  if Rails.env.production?
    default_url_options[:host] = "robocent.mhbweb.com"
  else
    default_url_options[:host] = "localhost:3000"
  end

  def activation_needed_email(user)
    @user = user
    @url  = activate_url(user.activation_token)
    headers['X-SMTPAPI'] = "{\"category\" : \"Activation Needed\"}"
    mail(:to      => user.email,
      :subject => "Activation Required - Robocent")
  end

  def activation_success_email(user)
    @user = user
    @url  = login_url
    headers['X-SMTPAPI'] = "{\"category\" : \"Welcome Email\"}"
    mail(:to => user.email,
      :subject => "Your account is now activated - Robocent")
  end

  def reset_password_instructions(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    headers['X-SMTPAPI'] = "{\"category\" : \"Password Help\"}"
    mail(:to => user.email,
      :subject => "Your password reset request - Robocent")
  end

end