class JoinCompanyUser < ActiveRecord::Migration
  def change
    create_join_table :companies, :users do |t|
      t.index [:user_id, :company_id]
      t.index [:company_id, :user_id]
    end
  end
end
