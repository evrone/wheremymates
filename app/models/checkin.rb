class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  attr_accessible :uid, :latitude, :longitude, :checked_at, :place, :desc, :link

  validates :latitude, :longitude, :presence => true

  def checkin_id
    id
  end
end
