class CreateMasterExamUserJoinTable < ActiveRecord::Migration
  def change
    create_table :master_exams_users, :id => false do |t|
      t.integer :master_exam_id
      t.integer :user_id
    end
  end
end