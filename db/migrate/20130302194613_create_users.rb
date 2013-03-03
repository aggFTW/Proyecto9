class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :fname, :null => false
      t.string :lname, :null => false
      t.integer :type, :null => false
      t.string :spassword, :null => false
      t.string :salt, :null => false

      t.timestamps
    end
  end
end
