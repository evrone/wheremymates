class Account < ActiveRecord::Base
  belongs_to :user
  has_many :checkins, :dependent => :destroy, :order => 'checked_at desc', :extend => CheckinAssociationExtensions

  attr_accessible :provider, :uid, :token, :expires_at

  LOCATION_PROVIDERS = %w(foursquare facebook)

  scope :facebook, where(:provider => 'facebook')
  scope :foursquare, where(:provider => 'foursquare')
  scope :near_expiring, ->{ where 'expires_at is null or expires_at < ?', Time.now + 1.hour }

  validates :provider, presence: true, inclusion: {in: LOCATION_PROVIDERS}

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
      account.expires_at = Time.at(auth[:credentials][:expires_at]) if account.provider.facebook?
    end
  end

  def import_locations
    if provider.foursquare?
      client = Foursquare2::Client.new(oauth_token: token)
      data = client.user_checkins
      checkins.create_for_foursquare(data.items)
    elsif provider.facebook?
      graph = Koala::Facebook::API.new(token)
      data = graph.get_connections("me", "feed", with: 'location') rescue nil
      checkins.create_for_facebook(data)
    end
  end

  def extend_facebook_token
    return unless provider.facebook?
    return if token.blank?
    oauth = Koala::Facebook::OAuth.new Settings.facebook.key, Settings.facebook.secret
    if access_token = oauth.exchange_access_token(token)
      update_attributes token: access_token, expires_at: Time.now + 30.days
    end
  end

  def provider
    super.inquiry
  end

  def provider_name
    provider.titleize
  end

  def userpage_url
    Settings.send(provider).userpage.gsub(':uid', uid)
  end
end
