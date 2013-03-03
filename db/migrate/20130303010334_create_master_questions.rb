class CreateMasterQuestions < ActiveRecord::Migration
  def change
    create_table :master_questions do |t|
      t.string :language
      t.string :solver
      t.string :randomizer
      t.string :inquiry
      t.string :concept
      t.string :subconcept

      t.timestamps
    end
  end
end
