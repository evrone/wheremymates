OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, Settings.foursquare_key, Settings.foursquare_secret
  provider :facebook, Settings.facebook_key, Settings.facebook_secret
end
