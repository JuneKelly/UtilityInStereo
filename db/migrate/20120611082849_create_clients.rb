class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.text :description
      t.string :website
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
