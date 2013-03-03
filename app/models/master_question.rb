class MasterQuestion < ActiveRecord::Base
  has_many :master_exams, :through => :exam_definition
  has_many :questions

  validates :concept,	:presence => true
  validates :inquiry,	:presence => true
  validates :language,	:presence => true
  validates :randomizer, :presence => true
  validates :solver,	:presence => true
  validates :subconcept, :presence => true

  attr_accessible :concept, :inquiry, :language, :randomizer, :solver, :subconcept
end