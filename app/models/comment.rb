class Comment < ActiveRecord::Base
  belongs_to :meetup
  belongs_to :user
  validates :user, presence: true
  validates :meetup, presence: true
end
