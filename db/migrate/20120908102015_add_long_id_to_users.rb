require 'securerandom'

class AddLongIdToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :long_id
    end
    add_index :users, :long_id, unique: true
  end
end
