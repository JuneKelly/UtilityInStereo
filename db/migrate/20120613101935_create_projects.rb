class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :details
      t.float :quotation, default: 0.0
      t.boolean :is_done, default: false
      t.float :hourly_rate, default: 0.0
      t.float :deposit, default: 0.0
      t.boolean :deposit_paid, default: false
      t.boolean :is_paid_in_full, default: false
      t.integer :client_id
      t.date :deadline

      t.timestamps
    end
  end
end
