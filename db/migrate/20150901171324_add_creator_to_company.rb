class AddCreatorToCompany < ActiveRecord::Migration
  def change
    add_reference :companies, :user, foreign_key: true
  end
end
