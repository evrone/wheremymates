set :output, "/home/deploy/projects/wheremymates/shared/log/cron.log"
set :job_template, nil
ruby_path = "/home/deploy/.rbenv/versions/1.9.3-p194/bin/ruby"
job_type :rake, "cd :path && RAILS_ENV=:environment #{ruby_path} bin/rake :task --silent :output"

every 30.minutes do
  rake "app:location"
end
