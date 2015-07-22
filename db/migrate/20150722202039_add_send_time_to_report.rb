class AddSendTimeToReport < ActiveRecord::Migration
  def change
    add_column :reports, :send_time, :string
  end
end
