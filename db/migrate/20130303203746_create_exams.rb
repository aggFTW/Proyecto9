class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.references :master_exam
      t.references :user
      t.string :state
      t.timestamp :date
      t.float :score

      t.timestamps
    end
    add_index :exams, :master_exam_id
    add_index :exams, :user_id
  end
end
