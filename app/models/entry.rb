class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :team, :counter_cache => true
end
