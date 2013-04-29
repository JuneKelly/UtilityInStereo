class AddTrialExpireToUsers < ActiveRecord::Migration
  def change
    add_column :users, :trial_expire, :datetime,
                null: false, default: 14.days.from_now
  end
end
