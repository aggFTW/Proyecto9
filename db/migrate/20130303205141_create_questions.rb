class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :exam
      t.references :master_question
      t.integer :questionNum
      t.text :values
      t.text :answers
      t.string :correctAns
      t.string :givenAns

      t.timestamps
    end
    add_index :questions, :exam_id
    add_index :questions, :master_question_id
  end
end
