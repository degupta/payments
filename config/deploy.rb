# ========================== Capistrano settings =============================================
# Default value for :pty is false
set :pty, true # Must be set for the password prompt from git to work

# Default value for :linked_files is []
# set :linked_files, %w{.env config/mongoid.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# :deploy_to is default: -> { "/var/www/#{fetch(:application)}" }
set :application, "payments"
set :user,        "ubuntu"
set :repo_url,    "git@github.com:degupta/payments.git"
ask :branch,      "master"

# RVM - adapted from https://rvm.io/integration/capistrano/
set :rvm_ruby_version, '2.2.1'
# ========================== Capistrano settings =============================================

# ========================== Server ==========================================================
server "ec2-52-88-94-73.us-west-2.compute.amazonaws.com",
  roles: %w(app web worker),
  user: fetch(:user),
  ssh_options: {
    forward_agent: true,
    keys: ["config/keys/payments2.pem"]
  }
# ========================== Server ==========================================================

# ========================== Helper functions ================================================
def from_template(file)
  require 'erb'
  template = File.read(File.join(File.dirname(__FILE__), "..", file))
  ERB.new(template).result(binding)
end
# ========================== Helper functions ================================================


# -------------------------- Deployment ---------------------------------------------------------
namespace :deploy do
  before :starting, 'yum:update_all'

  # This is the main sequence of tasks associated with restarting the product
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute 'cp /var/www/payments/.env /var/www/payments/current'
      invoke 'nginx:restart'
    end

    on roles(:app), in: :sequence, wait: 5 do
      invoke 'database:migrate'
    end
  end

  after :publishing, :restart
end
# -------------------------- Deployment ---------------------------------------------------------


# -------------------------- Tasks for the app server - Nginx --------------------------------
namespace :nginx do
  task :restart do
    on roles(:web), in: :sequence do
      execute "sudo service nginx restart"
    end
  end

  task :configure do
    on roles(:web), in: :sequence do |server|
      # we need sudo permissions to copy to /etc, so, since we can't pass them with scp, copy the file on the server
      upload! "config/deploy/nginx", "nginx"
      execute "sudo mv ~/nginx /etc/init.d/nginx"
      # grab current paths, put them in the local nginx.conf template and upload the generated file to the server
      @passenger_paths = capture 'cat /opt/nginx/conf/nginx.conf | grep passenger | grep gems'
      @server_name = server.hostname
      @rails_env = fetch(:rails_env)
      upload! StringIO.new(from_template("config/nginx.conf.erb")), "nginx.conf"
      execute "sudo mv ~/nginx.conf /opt/nginx/conf/nginx.conf"
    end
  end

  task :configtest do
    on roles(:web), in: :sequence do
      # This will complain about missing certificate files. That's ok because those are part of the codebase and will be installed with the first deploy.
      # All other errors are important, however!
      execute "sudo service nginx configtest"
    end
  end

  before :restart, :configure
  after :configure, :configtest
end
# -------------------------- Tasks for the app server - Nginx --------------------------------


# -------------------------- Indexing and other db-related tasks -----------------------------
namespace :database do
 task :restart do
  on roles(:app), in: :sequence do
    execute "sudo service postgresql restart"
  end
 end

  task :create do
    on roles(:app), in: :sequence do
      # Creates new indices and overwrites unchanged indices
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  task :migrate do
    on roles(:app), in: :sequence do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:migrate"
        end
      end
    end
  end

  before :create, :restart
  before :migrate, :restart
end
# -------------------------- Indexing and other db-related tasks -----------------------------


# -------------------------- Tasks for installing everything --------------------------------
namespace :yum do
  task :update_all do
    on roles(:all), in: :sequence do
      execute "sudo apt-get update -y"
    end
  end

  task :install_all do
    on roles(:all), in: :sequence do
      execute "sudo apt-get install -y git gcc-c++ libcurl-devel patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel git-core ImageMagick ImageMagick-devel"
    end
  end
  before :install_all, :update_all
end
# -------------------------- Tasks for installing everything --------------------------------
