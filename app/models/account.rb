class Account < ActiveRecord::Base
  belongs_to :user
  has_many :checkins, :dependent => :destroy, :order => 'checked_at desc'

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
      if data.items.present?
        data.items.map do |item|
          begin
            checkins.where(uid: item.id, user_id: user_id).first_or_create do |checkin|
              location = item.venue.location
              checkin.latitude = location.lat
              checkin.longitude = location.lng
              checkin.checked_at = Time.at item.createdAt
              checkin.place = [location.city, location.country].reject(&:blank?).join(', ')
              checkin.desc = item.shout || item.venue.name
              checkin.link = item.venue.canonicalUrl
            end
          rescue
            false
          end
        end
      end
    elsif provider.facebook?
      graph = Koala::Facebook::API.new(token)
      data = graph.get_connections("me", "feed", with: 'location') rescue nil
      if data.present?
        data.map do |post|
          begin
            post = Hashie::Mash.new(post)
            checkins.where(uid: post.id, user_id: user_id).first_or_create do |checkin|
              location = post.place.location
              checkin.latitude = location.latitude
              checkin.longitude = location.longitude
              checkin.checked_at = post.created_time
              checkin.place = [location.city, location.country].reject(&:blank?).join(', ')
              checkin.desc = post.story
              checkin.link = post.actions.first.link
            end
          rescue
            false
          end
        end
      end
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
