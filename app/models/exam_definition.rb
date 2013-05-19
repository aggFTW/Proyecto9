#encoding: utf-8
class ExamDefinition < ActiveRecord::Base
  belongs_to :master_exam
  belongs_to :master_question

  validates :master_exam,		:presence => true
  validates :master_question,	:presence => true
  validates :questionNum,	:presence => true,
  							:numericality => { :only_integer => true,
  										:greater_than_or_equal_to => 0 }
  validates :weight,		:presence => true,
  							:numericality => {  :greater_than_or_equal_to => 0.0,
  												:less_than_or_equal_to => 1.0 }

  attr_accessible :questionNum, :weight, :master_exam, :master_question
end