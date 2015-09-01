class Reminder < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :company
  validates_presence_of :party
  validates_presence_of :bill_date
  validates_presence_of :bill_no
  validates_presence_of :amount
  validates_presence_of :due_date
  validates_presence_of :broker
  validates_presence_of :broker_number
  validates_presence_of :party_number
  validates_presence_of :repeat
end
