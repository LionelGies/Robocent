if Rails.env.production? or Rails.env.staging?
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "robocent.mhbweb.com",
    :user_name            => "contact@mhbweb.com",
    :password             => "qwerty$123",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
end