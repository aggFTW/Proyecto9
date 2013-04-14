class RenameCantake < ActiveRecord::Migration
	def change
		rename_table :can_take, :cantakes
	end
end