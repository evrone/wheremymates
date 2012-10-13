class Account < ActiveRecord::Base
  belongs_to :user

  attr_accessible :provider, :uid

  LOCATION_PROVIDERS = %w(foursquare)

  def self.from_omniauth(user, auth)
    raise "user required" unless user
    raise "#{auth[:provider]} is not a location provider" unless LOCATION_PROVIDERS.include?(auth[:provider])

    where(auth.slice("provider", "uid")).first || create_from_omniauth(user, auth)
  end

  def self.create_from_omniauth(user, auth)
    create! do |account|
      account.user = user
      account.uid = auth["uid"]
      account.provider = auth["provider"]
    end
  end
end
