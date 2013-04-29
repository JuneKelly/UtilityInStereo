class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :role
      t.string :email
      t.string :phone
      t.integer :client_id

      t.timestamps
    end
  end
end
