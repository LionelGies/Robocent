set(:ruby_version)      { '1.9.3-p286' }
set(:rvm_ruby_string)   { "1.9.3-p286" }

set :application, "ec2-50-112-207-42.us-west-2.compute.amazonaws.com"
set :deploy_to, "/vol/apps/robocent"
set :rails_env, "production"
set :ruby_path, "/usr/local/rvm/rubies/ruby-1.9.3-p286/bin/ruby"
set :branch, 'master'

role :web, "ec2-50-112-207-42.us-west-2.compute.amazonaws.com" # Your HTTP server, Apache/etc
role :app, "ec2-50-112-207-42.us-west-2.compute.amazonaws.com" # This may be the same as your `Web` server
role :db, "ec2-50-112-207-42.us-west-2.compute.amazonaws.com", :primary => true # This is where Rails migrations will run
role :db, "ec2-50-112-207-42.us-west-2.compute.amazonaws.com"

