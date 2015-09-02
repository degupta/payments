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

  validate :validate_dates

  private

  def validate_dates
    if self.due_date && self.bill_date && self.due_date < self.bill_date
      errors.add(:due_date, "Due Date must be after bill date")
    end
  end
end
