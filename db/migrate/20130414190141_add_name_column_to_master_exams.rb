class AddNameColumnToMasterExams < ActiveRecord::Migration
  def change
    add_column :master_exams, :name, :string
  end
end
