class EventAdjust < ActiveRecord::Migration

  def change
    change_table :events do |t|
      t.datetime  :start_at
      t.datetime  :end_at
      t.boolean   :all_day, default: false
      t.remove    :start_date, :end_date, :start_time, :end_time
    end
  end
end
