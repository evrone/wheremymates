desc "Update location from 4square"
task "app:location" => :environment do
  Account.find_each(&:import_locations)
  puts "[#{Time.now}] DONE"
end
