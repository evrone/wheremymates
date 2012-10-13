desc "Update location from 4square"
task "app:location" => :environment do
  User.find_each(&:update_location)
  puts "[#{Time.now}] DONE"
end
