class AddAddIsAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean, default: false
    User.all.each do |user|
      user.is_admin = false
      user.save
    end
  end
end
