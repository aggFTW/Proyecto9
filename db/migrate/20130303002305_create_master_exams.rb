class CreateMasterExams < ActiveRecord::Migration
  def change
    create_table :master_exams do |t|
      t.integer :attempts
      t.timestamp :startDate
      t.timestamp :finishDate
      t.references :user
      t.timestamp :dateCreation

      t.timestamps
    end
    add_index :master_exams, :user_id
  end
end
