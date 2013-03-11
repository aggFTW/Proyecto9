class Group < ActiveRecord::Base
  belongs_to :user#, :inverse_of => :group
  has_and_belongs_to_many :users#, :inverse_of => :groups

  attr_accessible :name

  validates :name,	:presence => true
  validates :user,	:presence => true
end
