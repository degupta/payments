class Company < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :reminders

  validates_length_of :name, :minimum => 5, :maximum => 100
  validates_presence_of :user_id

  def as_json(options = {})
    {
      id: id,
      name: name
    }
  end

  def pending_reminders
    self.reminders
  end
end
