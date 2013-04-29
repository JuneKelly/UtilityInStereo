class AddLongIdToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string :long_id
    end
    add_index :projects, :long_id, unique: true
  end
end
