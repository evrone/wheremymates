set :output, "/var/www/apps/railsrumble/current/log/cron_log.log"
set :job_template, nil

every 5.minutes do
  rake "app:location"
end
