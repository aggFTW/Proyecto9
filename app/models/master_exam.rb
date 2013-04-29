class MasterExam < ActiveRecord::Base
  belongs_to :user
  has_many :cantakes
  has_many :users, :through => :cantakes
  has_many :master_questions, :through => :exam_definition
  has_many :exams

  validates :name, presence: true
  validates :dateCreation,	:presence => true
  validates :attempts,	:presence => true,
  						:numericality => { 	:only_integer => true,
  										:greater_than_or_equal_to => 1 }
  validates :startDate,	:presence => true
  validates :finishDate,	:presence => true
  validates :user, :presence => true

  attr_accessible :attempts, :dateCreation, :finishDate, :startDate, :name, :user
end
