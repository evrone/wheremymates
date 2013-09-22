set :job_template, nil
ruby_path = "rbenv exec"
job_type :rake, "cd :path && RAILS_ENV=:environment #{ruby_path} bundle exec rake :task --silent :output"

every 30.minutes do
  rake "app:location"
end

every 30.minutes do
  rake 'app:extend_facebook_tokens'
end
