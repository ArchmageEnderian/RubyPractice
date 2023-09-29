class AddEncryptedFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :encrypted_name, :string
    add_column :users, :encrypted_name_iv, :string
    add_column :users, :encrypted_email, :string
    add_column :users, :encrypted_email_iv, :string
    add_column :users, :encrypted_phone_number, :string
    add_column :users, :encrypted_phone_number_iv, :string
  end
end
