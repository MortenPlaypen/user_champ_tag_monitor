class Report < ActiveRecord::Base
  validates_formatting_of :recipient_email, using: :email
  belongs_to :user
end
