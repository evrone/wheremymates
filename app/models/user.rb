class User < ActiveRecord::Base
  attr_accessible :email, :latitude, :longitude

  validates :email, :presence => true
end
