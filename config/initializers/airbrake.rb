Airbrake.configure do |config|
  config.api_key = 'dc542140db30494abd73c8482e9e6d84'
  config.host    = 'errbit.vm.evrone.ru'
  config.port    = 80
  config.secure  = config.port == 443
  config.rescue_rake_exceptions = true
end
