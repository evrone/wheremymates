OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :foursquare, "QOUC2ILLMDQ2UQMFOPLQJ4OTGBDG2R1UKBSMH5M5G15BOZTF", "ZXYLOXLP33Q2EAYJVJJLQFGFSW0VNB14NRH2FE4CKHOHVDEW"
  provider :facebook, "376432435769798", "c39c4bf6abfa459abd55435a602ca736"
end
