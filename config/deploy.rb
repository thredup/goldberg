#############################################################
# Application & Server
#############################################################

set :application, "ci.thredup.com"

set :user, "thredup"
set :domain, "ci.thredup.com"
set :port, 35987
server domain, :app, :web
role :db, domain, :primary => true

set :deploy_to, "/home/#{user}/apps/#{application}"

#############################################################
# Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production"

#############################################################
# Git
#############################################################

set :scm, :git
set :branch, "custom"
ssh_options[:keys] = %w(~/.ec2/id_thredupkids)
#set :scm_passphrase, "pass@word1"
set :repository, "git@github.com:thredup/goldberg.git"
set :deploy_via, :remote_cache

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.2@goldberg"
set :rvm_type, :user

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

# before "deploy", "deploy:bundle_gems"
before "deploy:restart", "deploy:bundle_gems"
#after "deploy:bundle_gems", "deploy:restart"
#after "deploy:bundle_gems", "deploy:restart"

namespace :deploy do
  task :bundle_gems do
    run "cd #{current_path}; bundle install" 
  end

  task :start, :roles => :app, :except => { :no_release => true} do
    run "god start goldberg.unicorn"
  end

  task :stop, :roles => :app, :except => { :no_release => true} do
    run "god stop goldberg.unicorn"
    sleep 5
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
#before("deploy:symlink", "deploy:shutdown_unicorn")
#before("deploy:restart", "deploy:bundle")