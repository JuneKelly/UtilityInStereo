class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.string :name
      t.string :email
      t.text :message
      t.integer :user_id
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
