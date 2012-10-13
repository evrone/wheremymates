class User < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :team, :name
  attr_accessible :latitude, :longitude, :as => :geo_data

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

  def account(provider)
    accounts.where(provider: provider).first
  end

  def update_location
    if accounts.any?
      location = accounts.first.get_location
      if location[:created_at] > location_updated_at
        self.location_updated_at = Time.now
        update_attributes!(location)
      end
    end
  end
end
