source 'https://rubygems.org'

gem 'rails', '3.2.10'

gem 'mysql2'
gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-rails'
gem 'haml-rails'
gem 'capistrano'
gem 'airbrake'
gem 'foursquare2'
gem 'koala'
gem 'settingslogic'

# In v0.8.1 there is bug, when capistrano try to run whenever commands as my local user, not deploy
gem 'whenever', '0.8.0', :require => false

gem 'libv8'
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"

gem 'omniauth-foursquare'
gem 'omniauth-facebook'

group :development do
  gem 'capistrano-mountaintop'
  gem 'dev_must_have', github: 'evrone/dev_must_have'
  gem 'quiet_assets'
  gem 'commands'
end
