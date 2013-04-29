class AddExtendedFieldsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :account_type
      t.datetime :last_login
      t.boolean :is_active
    end
  end
end
