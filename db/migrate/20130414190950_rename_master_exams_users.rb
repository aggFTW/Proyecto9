class RenameMasterExamsUsers < ActiveRecord::Migration
	def change
		rename_table :master_exams_users, :can_take
		add_column :can_take, :attempts, :integer

		print "Change your associations for User and MasterExam to has_many :through => :cantakes and has_many :cantakes"
	end
end