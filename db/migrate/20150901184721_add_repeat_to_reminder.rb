class AddRepeatToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :repeat, :integer
    add_column :reminders, :last_reminder, :date
  end
end
