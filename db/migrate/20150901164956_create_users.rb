class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :hashed_password

      t.timestamps
    end

    add_index :users, :name
    add_index :users, :email, unique:true
  end
end
