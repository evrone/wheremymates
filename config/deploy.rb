# группа настроек для rbenv
set :rbenv_ruby_version, "1.9.3-p194"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  'RBENV_VERSION' => rbenv_ruby_version
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :rake, "bin/rake"
set :whenever_command, "bin/whenever"
ssh_options[:forward_agent] = true

require 'bundler/capistrano'

set :application, "wheremymates"
set :rails_env, "production"
set :domain, "deploy@5.9.85.89"
set :repository,  "git@github.com:evrone/wheremymates.git"
set :branch, "master"
set :use_sudo, false
set :deploy_to, "/home/deploy/projects/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :scm, :git

role :app, domain
role :web, domain
role :db,  domain, primary: true

require "whenever/capistrano"

namespace :deploy do
  desc "Restart Unicorn and Resque"
  task :restart do
    run "sv restart ~/services/#{application}_unicorn"
    #run "sv restart ~/services/#{application}_resque"
  end

  desc "Make symlinks"
  task :make_symlinks, roles: :app, except: { no_release: true } do
    # Ставим симлинк на конфиги и загрузки
    run "rm -f #{latest_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"

    run "rm -rf #{latest_release}/public/uploads"
    run "ln -s #{deploy_to}/shared/uploads #{latest_release}/public/uploads"
  end
end

after 'deploy:finalize_update', 'deploy:make_symlinks'

after "deploy:update", "deploy:cleanup"

require './config/boot'
require 'airbrake/capistrano'
load 'deploy/assets'
