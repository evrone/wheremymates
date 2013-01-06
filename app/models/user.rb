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
        if account.provider.facebook?
          account.update_attributes token: auth[:credentials][:token], expires_at: Time.at(auth[:credentials][:expires_at])
        end
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

  def merge(another_user)
    self.accounts += another_user.accounts
    self.entries += another_user.entries
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
    @last_checkin ||= checkins.first_or_initialize
  end

  delegate :latitude, :longitude, :place, :checked_at, :checkin_id, :to => :last_checkin

  def avatar_url
    if accounts.facebook.present?
      "http://graph.facebook.com/#{accounts.facebook.first.uid}/picture"
    else
      # fallback
      "http://img.brothersoft.com/icon/softimage/r/ruby-120627.jpeg"
    end
  end
end
