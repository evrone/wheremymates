class MoveGeoDataToCheckins < ActiveRecord::Migration
  def up
    User.find_each do |user|
      latitude = user.read_attribute :latitude
      longitude = user.read_attribute :longitude
      user.checkins.create :latitude => latitude, :longitude => longitude, :checked_at => user.location_updated_at || Time.now
    end
  end

  def down
    Checkin.destroy_all
  end
end
