class ExamDefinition < ActiveRecord::Base
  belongs_to :master_exam
  belongs_to :master_question

  validates :master_exam_id,		:presence => true
  validates :master_question,	:presence => true
  validates :questionNum,	:presence => true,
  							:numericality => { :only_integer => true,
  										:greater_than_or_equal_to => 0 }
  validates :weight,		:presence => true,
  							:numericality => {  :greater_than_or_equal_to => 0.0,
  												:less_than_or_equal_to => 1.0 }

  attr_accessible :master_exam_id, :master_question_id, :questionNum, :weight
end