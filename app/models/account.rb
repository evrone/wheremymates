class Account < ActiveRecord::Base
  belongs_to :user
  has_many :checkins, :dependent => :destroy, :order => 'checked_at desc', :extend => CheckinAssociationExtensions

  attr_accessible :provider, :uid, :token, :expires_at

  LOCATION_PROVIDERS = %w(foursquare facebook twitter)

  scope :facebook, where(:provider => 'facebook')
  scope :foursquare, where(:provider => 'foursquare')
  scope :twitter, where(:provider => 'twitter')
  scope :near_expiring, ->{ where 'expires_at is null or expires_at < ?', Time.now + 1.hour }

  validates :provider, presence: true, inclusion: {in: LOCATION_PROVIDERS}

  class << self
    def from_omniauth(user, auth)
      raise "user required" unless user
      raise "#{auth[:provider]} is not a location provider" unless LOCATION_PROVIDERS.include?(auth[:provider])

      account = where(auth.slice("provider", "uid")).first || create_from_omniauth(user, auth)
      if account.user.nil?
        account.update_column :user_id, user.id
      elsif account.user != user.id
        user.merge(account.user)
      end
    end

    def create_from_omniauth(user, auth)
      create! do |account|
        account.user = user
        account.uid = auth[:uid]
        account.provider = auth[:provider]
        account.token = auth[:credentials][:token]
        account.expires_at = Time.at(auth[:credentials][:expires_at]) if account.provider.facebook?
      end
    end

    def import_foursquare
      foursquare.find_each(&:import_locations)
    end

    def import_facebook
      facebook.find_each(&:import_locations)
    end

    def import_twitter
      twitter.order(:updated_at).each(&:import_locations)
    rescue Twitter::Error::TooManyRequests => error
      false
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
    elsif provider.twitter?
      params = {count: 200, trim_user: true}
      params.merge! since_id: last_access if last_access.present?
      data = Twitter.user_timeline uid.to_i, params
      checkins.create_for_twitter(data)
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
