class User < ActiveRecord::Base
  has_many :accounts, dependent: :destroy

  attr_accessible :email, :latitude, :longitude

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
end
