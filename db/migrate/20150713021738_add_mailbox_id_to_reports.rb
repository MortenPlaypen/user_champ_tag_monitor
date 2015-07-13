class AddMailboxIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :mailbox_hsid, :string
  end
end
