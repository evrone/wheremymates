class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :entries, :dependent => :destroy
  has_many :users, :through => :entries

  before_create :set_invitation_key

  validates :name, :presence => true

private

  def set_invitation_key
    self.invitation_key = generate_invitation_key
  end

  def generate_invitation_key
    SecureRandom.hex(10)
  end

end
