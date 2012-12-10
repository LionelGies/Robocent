# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features (password encryption, login/logout).
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external
Rails.application.config.sorcery.submodules = [:core, :remember_me, :reset_password, :user_activation, :brute_force_protection, :activity_logging]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # -- core --
  # What controller action to call for non-authenticated users. You can also
  # override the 'not_authenticated' method of course.
  # Default: `:not_authenticated`
  #
  # config.not_authenticated_action =


  # When a non logged in user tries to enter a page that requires login, save
  # the URL he wanted to reach, and send him there after login, using 'redirect_back_or_to'.
  # Default: `true`
  #
  config.save_return_to_url = true


  # Set domain option for cookies; Useful for remember_me submodule.
  # Default: `nil`
  #
  # config.cookie_domain =


  # -- session timeout --
  # How long in seconds to keep the session alive.
  # Default: `3600`
  #
  # config.session_timeout =


  # Use the last action as the beginning of session timeout.
  # Default: `false`
  #
  # config.session_timeout_from_last_action =


  # -- http_basic_auth --
  # What realm to display for which controller name. For example {"My App" => "Application"}
  # Default: `{"application" => "Application"}`
  #
  # config.controller_to_realm_map =


  # -- activity logging --
  # will register the time of last user login, every login.
  # Default: `true`
  #
  config.register_login_time = true                                 # will register the time of last user login, every login.
  config.register_logout_time = true                                # will register the time of last user logout, every logout.
  config.register_last_activity_time = true                         # will register the time of last user action, every action.


  # will register the time of last user logout, every logout.
  # Default: `true`
  #
  # config.register_logout_time =


  # will register the time of last user action, every action.
  # Default: `true`
  #
  # config.register_last_activity_time =


  # -- external --
  # What providers are supported by this app, i.e. [:twitter, :facebook, :github, :google, :liveid] .
  # Default: `[]`
  #
  # config.external_providers =


  # You can change it by your local ca_file. i.e. '/etc/pki/tls/certs/ca-bundle.crt'
  # Path to ca_file. By default use a internal ca-bundle.crt.
  # Default: `'path/to/ca_file'`
  #
  # config.ca_file =


  # Twitter wil not accept any requests nor redirect uri containing localhost,
  # make sure you use 0.0.0.0:3000 to access your app in development
  #
  # config.twitter.key = ""
  # config.twitter.secret = ""
  # config.twitter.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=twitter"
  # config.twitter.user_info_mapping = {:email => "screen_name"}
  #
  # config.facebook.key = ""
  # config.facebook.secret = ""
  # config.facebook.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=facebook"
  # config.facebook.user_info_mapping = {:email => "name"}
  #
  # config.github.key = ""
  # config.github.secret = ""
  # config.github.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=github"
  # config.github.user_info_mapping = {:email => "name"}
  #
  # config.google.key = ""
  # config.google.secret = ""
  # config.google.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=google"
  # config.google.user_info_mapping = {:email => "email", :username => "name"}
  #
  # To use liveid in development mode you have to replace mydomain.com with
  # a valid domain even in development. To use a valid domain in development
  # simply add your domain in your /etc/hosts file in front of 127.0.0.1
  #
  # config.liveid.key = ""
  # config.liveid.secret = ""
  # config.liveid.callback_url = "http://mydomain.com:3000/oauth/callback?provider=liveid"
  # config.liveid.user_info_mapping = {:username => "name"}


  # --- user config ---
  config.user_config do |user|
    # -- core --
    user.username_attribute_names = [:email]                                          # specify username
                                                                                      # attributes, for example:
                                                                                      # [:username, :email].

    #user.password_attribute_name = :password                                        # change *virtual* password
                                                                                      # attribute, the one which is used
                                                                                      # until an encrypted one is
                                                                                      # generated.

    # user.downcase_username_before_authenticating = false                            # downcase the username before
                                                                                      # trying to authenticate, default
                                                                                      # is false

    # user.email_attribute_name = :email                                              # change default email attribute.

    # user.crypted_password_attribute_name =  :crypted_password                       # change default crypted_password
                                                                                      # attribute.

    # user.salt_join_token = ""                                                       # what pattern to use to join the
                                                                                      # password with the salt

    # user.salt_attribute_name = :salt                                                # change default salt attribute.

    # user.stretches = nil                                                            # how many times to apply
                                                                                      # encryption to the password.

    # user.encryption_key = nil                                                       # encryption key used to encrypt
                                                                                      # reversible encryptions such as
                                                                                      # AES256.
                                                                                      #
                                                                                      # WARNING:
                                                                                      #
                                                                                      # If used for users' passwords, changing this key
                                                                                      # will leave passwords undecryptable!

    # user.custom_encryption_provider = nil                                           # use an external encryption
                                                                                      # class.

    # user.encryption_algorithm = :bcrypt                                             # encryption algorithm name. See
                                                                                      # 'encryption_algorithm=' for
                                                                                      # available options.

    # user.subclasses_inherit_config = false                                          # make this configuration
                                                                                      # inheritable for subclasses.
                                                                                      # Useful for ActiveRecord's STI.

    # -- user_activation --
    user.activation_state_attribute_name = :activation_state                        # the attribute name to hold
                                                                                      # activation state
                                                                                      # (active/pending).

    user.activation_token_attribute_name = :activation_token                        # the attribute name to hold
                                                                                      # activation code (sent by email).

    user.activation_token_expires_at_attribute_name = :activation_token_expires_at  # the attribute name to hold
                                                                                      # activation code expiration date.

    user.activation_token_expiration_period =  nil                                  # how many seconds before the
                                                                                      # activation code expires. nil for
                                                                                      # never expires.

    user.user_activation_mailer = Notification                                               # your mailer class. Required.

    user.activation_needed_email_method_name = :activation_needed_email             # activation needed email method
                                                                                      # on your mailer class.

    user.activation_success_email_method_name = :activation_success_email           # activation success email method
                                                                                      # on your mailer class.

    user.prevent_non_active_users_to_login = false                                   # do you want to prevent or allow
                                                                                      # users that did not activate by
                                                                                      # email to login?

    # -- reset_password --
    user.reset_password_token_attribute_name = :reset_password_token                          # reset password code
                                                                                                # attribute name.

    user.reset_password_token_expires_at_attribute_name = :reset_password_token_expires_at    # expires at attribute
                                                                                                # name.

    user.reset_password_email_sent_at_attribute_name = :reset_password_email_sent_at          # when was email sent,
                                                                                                # used for hammering
                                                                                                # protection.

    user.reset_password_mailer = Notification                                                          # mailer class. Needed.

    user.reset_password_email_method_name = :reset_password_instructions                            # reset password email
                                                                                                # method on your mailer
                                                                                                # class.

    user.reset_password_expiration_period = 86400 #24 hours                                        # how many seconds
                                                                                                # before the reset
                                                                                                # request expires. nil
                                                                                                # for never expires.

    user.reset_password_time_between_emails = 15                                          # hammering protection,
                                                                                                # how long to wait
                                                                                                # before allowing
                                                                                                # another email to be
                                                                                                # sent.

    # -- brute_force_protection --
    user.failed_logins_count_attribute_name = :failed_logins_count                  # failed logins attribute name.

    user.lock_expires_at_attribute_name = :lock_expires_at                          # this field indicates whether
                                                                                      # user is banned and when it will
                                                                                      # be active again.

    user.consecutive_login_retries_amount_limit = 10                               # how many failed logins allowed.

    user.login_lock_time_period = 10 * 60                                           # how long the user should be
                                                                                      # banned. in seconds. 0 for
                                                                                      # permanent.

    # -- activity logging --
    user.last_login_at_attribute_name = :last_login_at                              # last login attribute name.
    user.last_logout_at_attribute_name = :last_logout_at                            # last logout attribute name.
    user.last_activity_at_attribute_name = :last_activity_at                        # last activity attribute name.
    user.activity_timeout = 10 * 60                                                 # how long since last activity is
                                                                                      # the user defined logged out?

    # -- external --
    # user.authentications_class = nil                                                # class which holds the various
                                                                                      # external provider data for this
                                                                                      # user.

    # user.authentications_user_id_attribute_name = :user_id                          # user's identifier in
                                                                                      # authentications class.

    # user.provider_attribute_name = :provider                                        # provider's identifier in
                                                                                      # authentications class.

    # user.provider_uid_attribute_name = :uid                                         # user's external unique
                                                                                      # identifier in authentications
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = "User"
end
