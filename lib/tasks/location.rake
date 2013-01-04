desc "Update location from 4square"
task "app:location" => :environment do
  puts "Start app:location"
  Account.find_each(&:import_locations)
  puts "[#{Time.now}] DONE\n\n"
end

desc "Extend tokens that near expiring"
task 'app:extend_facebook_tokens' => :environment do
  puts "Start app:extend_facebook_tokens"
  Account.facebook.near_expiring.each(&:extend_facebook_token)
  puts "[#{Time.now}] DONE\n\n"
end
