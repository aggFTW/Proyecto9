class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :spassword, :type, :username

  has_and_belongs_to_many :groups #, :inverse_of => :users
  has_and_belongs_to_many :master_exams #, :inverse_of => :users
  has_many :exams #, :inverse_of => :user

  validates :username,	:presence => true,
  						:uniqueness => true,
  						:length => { :is => 9 }
  validates :fname,	:presence => true
  validates :lname,	:presence => true
  validates :type,	:presence => true,
          					:numericality => { 	:only_integer => true,
          										:less_than => 3,
          										:greater_than_or_equal_to => 0 }
  #validates :salt,	:presence => true
  validates :spassword,	:presence => true


  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
     if spassword.present?
      self.salt = BCrypt::Engine.generate_salt
      self.spassword= BCrypt::Engine.hash_secret(spassword, salt)
    end
  end

  def clear_password
    self.spassword = nil
  end

end
