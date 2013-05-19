#encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :spassword, :username, :spassword_confirmation, :group_ids

  has_and_belongs_to_many :groups #, :inverse_of => :users
  has_many :cantakes
  has_many :master_exams, :through => :cantakes #, :inverse_of => :users
  has_many :exams #, :inverse_of => :user

  validates :username,	:presence => true,
  						:uniqueness => true,
  						:length => { :is => 9 }
  validates :fname,	:presence => true
  validates :lname,	:presence => true
  validates :utype,	:presence => true,
          					:numericality => { 	:only_integer => true,
          										:less_than => 3,
          										:greater_than_or_equal_to => 0 }
  #validates :salt,	:presence => true
  VALID_PASSWORD_REGEX = /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$/
  validates :spassword,	:presence => true
  validates_confirmation_of :spassword, message: "debería coincidir con el password", presence: true


  before_save :encrypt_password, :normalizeAttributes
  after_save :clear_password

  def encrypt_password
    debugger
    if self.spassword.present?
      if new_record?
        self.salt = BCrypt::Engine.generate_salt
      end
      self.spassword= BCrypt::Engine.hash_secret(self.spassword, self.salt)
    else
      false
    end
    debugger
  end

  def clear_password
    self.spassword = nil
  end

  def normalizeAttributes
    debugger
    self.username = self.username.downcase

    f = ""
    for t in self.fname.split(' ')
      f += t.capitalize + ' '
    end
    self.fname = f.lstrip

    l = ""
    for t in self.lname.split(' ')
      l += t.capitalize + ' '
    end

    self.lname = l.lstrip
  end



  def self.authenticate(gusername="", gspassword="")
    gusername = gusername.downcase
    user = User.find_by_username(gusername)

    if user && user.match_password(gspassword)
      return user
    else
      return false
    end
  end   

  def match_password(gspassword="")
    self.spassword == BCrypt::Engine.hash_secret(gspassword, self.salt)
  end

end
