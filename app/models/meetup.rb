class Meetup < ActiveRecord::Base
  has_many :attendance_lists
  has_many :users, through: :attendance_lists
  has_many :comments
end
