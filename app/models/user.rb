class User < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :team, :name, :country, :city
  attr_accessible :latitude, :longitude, :location_updated_at, :as => :geo_data

  has_many :accounts, dependent: :destroy

  belongs_to :team

  def self.from_omniauth(auth)
    where(auth.slice("uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.uid = auth["uid"]
      user.name = auth["info"]["name"].presence || auth["info"]["nickname"]
    end
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

  def update_location
    return unless accounts.any?

    location = accounts.first.get_location
    if location
      should_replace_location = location_updated_at.nil? || location[:created_at] > location_updated_at
      if should_replace_location
        self.location_updated_at = Time.now
        update_attributes!(location.slice(:latitude, :longitude, :country, :city))
      end
    end
  end
end
