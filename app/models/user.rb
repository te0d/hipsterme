class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # login field can be either username or email
  attr_accessor :login
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me
  
  # allow users to add friends to follow (one-way)
  has_many :friends
  
  # allow users to promote bands through the bumps table
  has_many :bumps
  has_many :bands, :through => :bumps
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  # allows login field to identify the username or email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def invested_cred
    self.bumps.where(:unbumped_at => nil).sum :cred_value
  end
end
