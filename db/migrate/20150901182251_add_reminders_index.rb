class AddRemindersIndex < ActiveRecord::Migration
  def change
    add_index :reminders, :party
    add_index :reminders, :due_date
    add_index :reminders, :company_id
  end
end
