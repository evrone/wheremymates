set :output, "/var/www/apps/railsrumble/current/log/cron_log.log"

every 10.minutes do
  rake "app:location"
end
