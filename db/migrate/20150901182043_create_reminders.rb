class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :party
      t.date :bill_date
      t.string :bill_no
      t.decimal :amount
      t.date :due_date
      t.string :broker
      t.string :party_number
      t.string :broker_number
      t.belongs_to :company

      t.timestamps
    end
  end
end
