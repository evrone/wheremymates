class User < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :team, :name, :country, :city
  attr_accessible :latitude, :longitude, :location_updated_at, :as => :geo_data

  has_many :accounts, dependent: :destroy

  has_many :entries, :dependent => :destroy
  has_many :teams, :through => :entries
  has_many :checkins, :dependent => :destroy, :order => 'checked_at desc'

  class << self
    def from_omniauth(auth)
      account = Account.where(auth.slice("uid", "provider")).first
      if account.present?
        account.update_column :token, auth[:credentials][:token]
        account.user
      else
        create_from_omniauth(auth)
      end
    end

    def create_from_omniauth(auth)
      transaction do
        create! do |user|
          user.name = auth["info"]["name"].presence || auth["info"]["nickname"]
        end.tap do |user|
          Account.create_from_omniauth(user, auth)
        end
      end
    end
  end

  def part_of?(team)
    team_ids.include? team.id if team.present?
  end

  def has_account?(provider)
    accounts.exists?(provider: provider)
  end

  def has_not_account?(provider)
    !has_account?(provider)
  end

  def account(provider)
    accounts.where(provider: provider).first
  end

  def last_checkin
    @last_checkin ||= checkins.first
  end

  def latitude
    last_checkin.try :latitude
  end

  def longitude
    last_checkin.try :longitude
  end

  def update_location
    return unless accounts.foursquare.any?

    location = accounts.foursquare.first.get_location
    if location
      should_replace_location = location_updated_at.nil? || location[:created_at] > location_updated_at
      if should_replace_location
        self.location_updated_at = Time.now
        update_attributes!(location.slice(:latitude, :longitude, :country, :city))
      end
    end
  end

  def avatar_url
    if accounts.facebook.present?
      "http://graph.facebook.com/#{accounts.facebook.first.uid}/picture"
    else
      # fallback
      "http://img.brothersoft.com/icon/softimage/r/ruby-120627.jpeg"
    end
  end
end
