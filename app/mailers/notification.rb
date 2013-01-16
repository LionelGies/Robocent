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
      :subject => "Welcome to RoboCent!")
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

  def charge_succeeded(event_id)
    @event = BillingEvent.find(event_id)
    @user = @event.user
    require "yaml"
    @charge = HashWithIndifferentAccess.new(YAML.load @event.response)
    headers['X-SMTPAPI'] = "{\"category\" : \"Payment Succeeded\"}"
    mail(:to => @user.email,
      :subject => "Thanks for your payment!")
  end

  def charge_failed(event_id)
    @event = BillingEvent.find(event_id)
    @user = @event.user
    require "yaml"
    @charge = HashWithIndifferentAccess.new(YAML.load @event.response)
    headers['X-SMTPAPI'] = "{\"category\" : \"Payment Failed\"}"
    mail(:to => @user.email,
      :subject => "Your payment is failed!")
  end

  def recurring_payment(event_id)
    @event = BillingEvent.find(event_id)
    @user = @event.user
    require "yaml"
    @invoice = HashWithIndifferentAccess.new(YAML.load @event.response)
    headers['X-SMTPAPI'] = "{\"category\" : \"Payment Failed\"}"
    mail(:to => @user.email,
      :subject => "Monthly Subscription Fee!")
  end

  def recording_succeeded(recording)
    @user = recording.user
    rec_url = recording.file.url
    rec_url[0] = ''
    @rec_url = "#{root_url}#{rec_url}"

    headers['X-SMTPAPI'] = "{\"category\" : \"Recording\"}"
    mail(:to => @user.email,
      :subject => "New Robocent Recording")
  end
end