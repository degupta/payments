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

  def as_json(options = {})
    {
      id:            id,
      party:         party,
      party_number:  party_number,
      broker:        broker,
      broker_number: broker_number,
      bill_date:     bill_date.strftime("%d-%m-%Y"),
      bill_no:       bill_no,
      amount:        amount,
      due_date:      due_date.strftime("%d-%m-%Y"),
      repeat:        repeat,
      last_message:  (last_reminder ? last_reminder.strftime("%d-%m-%Y") : nil)
    }
  end

  private

  def validate_dates
    if self.due_date && self.bill_date && self.due_date < self.bill_date
      errors.add(:due_date, "must be after bill date")
    end
  end
end
