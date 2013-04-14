class AddAttemptnumberColumnToExams < ActiveRecord::Migration
  def change
    add_column :exams, :attemptnumber, :integer
  end
end
