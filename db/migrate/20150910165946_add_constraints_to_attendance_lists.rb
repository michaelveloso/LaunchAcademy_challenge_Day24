class AddConstraintsToAttendanceLists < ActiveRecord::Migration
  def change
    add_index :attendance_lists, [ :user_id, :meetup_id ], unique: true
  end
end
