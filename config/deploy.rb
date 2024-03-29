
# config valid only for Capistrano 3.1
lock '3.1.0'


set :application, 'gw-api'
set :repo_url, 'git@github.com:callowaylc/gw-api.git'
#set :ssh_options, { :forward_agent => true }

 # Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ubuntu/Develop/gw-api'

# Default value for :scm is :git
set :scm,    :git

# set server user
set :user,   "ubuntu"

# only setting for depoloyment to production here
set :rails_env,     "production"

# deployment will be done via copy
set :deploy_via, :remote_cache

# only keep the last 5 releases
set :keep_releases, 5

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#set :stages, [ "staging", "production" ]
#set :default_stage, "production"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')

      # restart unicorn server
      run "RAILS_ROOT=/var/www/api " +
          "RAILS_ENV=development   " +
          "/etc/init.d/unicorn restart"
    end
  end

  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end  

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
