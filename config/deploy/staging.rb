set(:ruby_version)      { '1.9.3-p194' }
set(:rvm_ruby_string)   { "1.9.3-p194" }

set :application, "ec2-50-112-5-90.us-west-2.compute.amazonaws.com"
set :deploy_to, "/vol/apps/robocent"
set :rails_env, "production --trace"
set :branch, 'master'

role :web, "ec2-50-112-5-90.us-west-2.compute.amazonaws.com" # Your HTTP server, Apache/etc
role :app, "ec2-50-112-5-90.us-west-2.compute.amazonaws.com" # This may be the same as your `Web` server
role :db, "ec2-50-112-5-90.us-west-2.compute.amazonaws.com", :primary => true # This is where Rails migrations will run
role :db, "ec2-50-112-5-90.us-west-2.compute.amazonaws.com"
