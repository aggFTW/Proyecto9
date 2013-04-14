class RemoveAttemptsColumnFromCantakes < ActiveRecord::Migration
  def change
    remove_column :cantakes, :attempts
  end
end
