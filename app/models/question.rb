class Question < ActiveRecord::Base
  belongs_to :exam
  belongs_to :master_question

  validates :exam,				:presence => true
  validates :master_question,	:presence => true
  validates :questionNum,	:presence => true,
  							:numericality => { :only_integer => true,
  												:greater_than_or_equal_to => 0 }
  validates :values,			:presence => true
  validates :answers,			:presence => true
  validates :correctAns, 		:presence => true
  validates :givenAns,	 		:presence => true

  attr_accessible :questionNum
end
