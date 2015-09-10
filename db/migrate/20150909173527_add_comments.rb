class AddComments < ActiveRecord::Migration
  def change
    create_table :comments do |table|
      table.string :title
      table.string :body, null: false
      table.belongs_to :meetup, null: false
      table.belongs_to :user, null: false

      table.timestamps
    end
  end
end
