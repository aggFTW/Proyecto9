class FixColumnNameUser < ActiveRecord::Migration
  def change
    rename_column :users, :type, :utype
  end
end