class Report < ActiveRecord::Base
  validates_formatting_of :recipient_email, using: :email
end
