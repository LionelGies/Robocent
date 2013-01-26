#if Rails.env.production? or Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "robocent.com",
    :user_name            => "info@robocent.com",
    :password             => "Ironman68",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
#end