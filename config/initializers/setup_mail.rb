if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "mhbweb.com",
    :user_name            => "contact@mhbweb.com",
    :password             => "qwerty$123",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
end