class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email,              null: false, default: ""
      t.string :avatar
      t.text :bio
      t.string :website
      t.string :phone_number
      t.string :gender
      t.boolean :private_account
      t.boolean :verified

      t.timestamps
    end
  end
end
