class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :details
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
