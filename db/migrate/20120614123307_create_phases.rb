class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :title, null: false
      t.text :details
      t.boolean :is_flat_rate, default: false
      t.float :flat_rate, default: 0.00
      t.date :due_date
      t.boolean :is_done, default: false
      t.integer :project_id

      t.timestamps
    end
  end
end
