class Account < ActiveRecord::Base
  belongs_to :user

  attr_accessible :provider, :uid

  LOCATION_PROVIDERS = %w(foursquare facebook)

  scope :facebook, where(:provider => 'facebook')
  scope :foursquare, where(:provider => 'foursquare')

  def self.from_omniauth(user, auth)
    raise "user required" unless user
    raise "#{auth[:provider]} is not a location provider" unless LOCATION_PROVIDERS.include?(auth[:provider])

    where(auth.slice("provider", "uid")).first || create_from_omniauth(user, auth)
  end

  def self.create_from_omniauth(user, auth)
    create! do |account|
      account.user = user
      account.uid = auth[:uid]
      account.provider = auth[:provider]
      account.token = auth[:credentials][:token]
    end
  end

  def get_location
    return unless provider == 'foursquare'
    client = Foursquare2::Client.new(oauth_token: token)

    latest_checkins = client.user('self').checkins(limit: 1)
    if latest_checkins.try(:items)
      checkin = latest_checkins.items.first
      location = checkin.venue.location
      {
        latitude: location.lat,
        longitude: location.lng,
        created_at: Time.at(checkin.createdAt),
        city: location.city,
        country: location.country,
      }
    else
      nil
    end
  end

  def provider_name
    provider.titleize
  end

  def userpage_url
    Settings.send(provider).userpage.gsub(':uid', uid)
  end
end
