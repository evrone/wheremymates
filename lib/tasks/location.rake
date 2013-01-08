desc "Update location from 4square"
task "app:location" => :environment do
  puts "Importing Foursquare"
  Account.import_foursquare
  puts "Importing Facebook"
  Account.import_facebook
  puts "Importing Twitter"
  Account.import_twitter

  puts "[#{Time.now}] DONE\n\n"
end

desc "Extend tokens that near expiring"
task 'app:extend_facebook_tokens' => :environment do
  puts "Start app:extend_facebook_tokens"
  Account.facebook.near_expiring.each(&:extend_facebook_token)
  puts "[#{Time.now}] DONE\n\n"
end
