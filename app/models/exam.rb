class Exam < ActiveRecord::Base
  belongs_to :master_exam
  belongs_to :user
  has_many :questions

  validates :state,	:presence => true
  validates :score,	:presence => true,
  					:numericality => { :greater_than_or_equal_to => 0.0,
  										:less_than_or_equal_to => 100.0 }

  attr_accessible :date
end
