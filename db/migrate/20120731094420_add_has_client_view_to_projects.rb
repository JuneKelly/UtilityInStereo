class AddHasClientViewToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.boolean :has_client_view, default: false
      t.text    :client_view_message
    end
  end
end
