class AddHelpscoutTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :helpscout_token, :string
  end
end
