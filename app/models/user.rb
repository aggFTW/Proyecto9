class User < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :fname, :lname, :spassword, :username, :spassword_confirmation
=======
  attr_accessible :fname, :lname, :spassword, :username, :group_ids
>>>>>>> groups fixed?

  has_and_belongs_to_many :groups #, :inverse_of => :users
  has_and_belongs_to_many :master_exams #, :inverse_of => :users
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
  validates :spassword,	:presence => true
  validates_confirmation_of :spassword, message: "should match password", presence: true


  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if spassword.present?
      if new_record?
        self.salt = BCrypt::Engine.generate_salt
      end
      self.spassword= BCrypt::Engine.hash_secret(spassword, salt)
    end
  end

  def clear_password
    self.spassword = nil
  end



  def self.authenticate(gusername="", gspassword="")
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
