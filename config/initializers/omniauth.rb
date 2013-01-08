OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, Settings.foursquare.key, Settings.foursquare.secret
  provider :facebook, Settings.facebook.key, Settings.facebook.secret, :scope => 'email,read_stream'
  provider :twitter, Settings.twitter.key, Settings.twitter.secret
end

Twitter.configure do |config|
  config.consumer_key = Settings.twitter.key
  config.consumer_secret = Settings.twitter.secret
  config.oauth_token = Settings.twitter.token
  config.oauth_token_secret = Settings.twitter.token_secret
end
