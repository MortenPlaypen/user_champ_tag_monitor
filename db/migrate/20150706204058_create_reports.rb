class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.string :tag
      t.string :recipient_email

      t.timestamps
    end
  end
end
