require 'eycap/recipes'

set :application, "localpolitics.in"

default_run_options[:pty] = true
set :scm, "git"
set :repository, "git@github.com:hashrocket/#{application}.git"
set :user, "root"

set :deploy_to, "/var/www/#{application}"

task :staging do
  role :web, "ec2-174-129-130-182.compute-1.amazonaws.com"
  role :app, "ec2-174-129-130-182.compute-1.amazonaws.com"
  role :db,  "ec2-174-129-130-182.compute-1.amazonaws.com", :primary => true
  set :ssh_options, {
    :keys => ["#{ENV['HOME']}/.ec2/id_rsa-hashrocket-utility-keypair"],
    :port => 4777
  }
  set :branch, 'staging'
end

task :production do
  role :web, "ec2-72-44-49-140.compute-1.amazonaws.com", :memcached => true
  role :app, "ec2-72-44-49-140.compute-1.amazonaws.com"
  role :db,  "ec2-72-44-49-140.compute-1.amazonaws.com", :primary => true
  set :branch, 'production'
end

set :rails_env, "production"

after "deploy:update_code", "deploy:symlink_config_files"

namespace :deploy do
  desc "Symlink config files from shared/config to release dir"
  task :symlink_config_files, :roles => [ :app ] do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/settings.yml #{release_path}/config/settings.yml"
    run "/etc/init.d/memcached start"
  end

  task :restart do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
end
