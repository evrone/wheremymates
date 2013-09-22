require "capistrano_evrone_recipes/capistrano"

set :repository, "git@github.com:evrone/wheremymates.git"
set :application, "wheremymates"
set :user, 'wheremymates'
set :branch, 'master'

server 'wheremymates@146.185.128.142', :web, :app, :worker, :crontab
role :db, 'wheremymates@146.185.128.142', primary: true
