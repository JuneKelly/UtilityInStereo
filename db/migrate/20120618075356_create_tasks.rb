class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.boolean :is_done, default: false
      t.integer :phase_id

      t.timestamps
    end
  end
end
