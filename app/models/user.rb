class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable
  # devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :omniauthable

  include DmUniboCommon::User

  ##attr_accessible :email, :name, :surname
  ##attr_accessible :admin, :as => :admin

  validates_presence_of :email
  validates_uniqueness_of :email

  #NOTE: we don't have an id in the courses_users table. 
  # We can't declare a composite primary key.
  # Exception raised with has_many -> UnknownPrimaryKey
  # Solution -> use has_and_belongs_to_many
  has_and_belongs_to_many :courses
 # has_many :courses_users
 # has_many :courses, :through => :courses_users
  has_many :changelogs
  has_many :packages, :through => :changelogs

  def is_admin?
    self.admin
  end

  def to_s
    if self.name
      self.name + " " + self.surname
    else
      self.email
    end
  end

  def ==(another_user)
    self.id == another_user.id
  end
end


