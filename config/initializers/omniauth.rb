OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, Settings.foursquare.key, Settings.foursquare.secret
  provider :facebook, Settings.facebook.key, Settings.facebook.secret
end
