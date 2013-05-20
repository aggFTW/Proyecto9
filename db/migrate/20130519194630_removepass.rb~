class ChangeUsers < ActiveRecord::Migration
  def change
    rename_column :users, :spassword, :password
    add_column :users, :password_digest, :string
  end
end