class CreateExamDefinitions < ActiveRecord::Migration
  def change
    create_table :exam_definitions do |t|
      t.references :master_exam
      t.references :master_question
      t.integer :questionNum
      t.float :weight

      t.timestamps
    end
    
    add_index :exam_definitions, :master_exam_id
    add_index :exam_definitions, :master_question_id
  end
end
