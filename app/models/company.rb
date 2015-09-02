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
    now = DateTime.now.to_date
    self.reminders.find_all do |r|
      if r.due_date > now
        false
      elsif r.last_reminder == nil
        true
      elsif r.due_date == now
        r.last_reminder != now
      elsif r.repeat <= 0
        false
      else
        (now - r.last_reminder).to_i >= r.repeat
      end
    end
  end
end
