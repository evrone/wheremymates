class Account < ActiveRecord::Base
  belongs_to :user
  has_many :checkins, :dependent => :destroy, :order => 'checked_at desc', :extend => CheckinAssociationExtensions

  attr_accessible :provider, :uid

  LOCATION_PROVIDERS = %w(foursquare facebook)

  scope :facebook, where(:provider => 'facebook')
  scope :foursquare, where(:provider => 'foursquare')

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
