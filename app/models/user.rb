class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable
  # devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :omniauthable

  ##attr_accessible :email, :name, :surname
  ##attr_accessible :admin, :as => :admin

  validates_presence_of :email
  validates_uniqueness_of :email

  # has_and_belongs_to_many :courses
  has_many :courses_users
  has_many :courses, :through => :courses_users
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

  # fake
  #def self.fake_authenticate(login)
  #  where(:email => login).first
  #  true
  #end
end


