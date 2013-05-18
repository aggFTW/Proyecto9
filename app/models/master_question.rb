class MasterQuestion < ActiveRecord::Base
  has_many :master_exams, :through => :exam_definition
  has_many :questions
  has_many :exam_definition

  validates :concept,	:presence => true
  validates :inquiry,	:presence => true
  validates :language,	:presence => true
  validates :randomizer, :presence => true
  validates :solver,	:presence => true
  validates :subconcept, :presence => true

  attr_accessible :concept, :inquiry, :language, :randomizer, :solver, :subconcept

  before_save :capitalizeAttributes

  def self.all_languages
    select("DISTINCT language")
  end

  def capitalizeAttributes
    self.language = self.language.capitalize
    self.concept = self.concept.capitalize
    self.subconcept = self.subconcept.capitalize
  end

end
