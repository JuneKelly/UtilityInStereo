class AddOrderIndexToPhase < ActiveRecord::Migration
  def change
    change_table :phases do |t|
      t.integer :order_index
    end
  end
end
