class User < ActiveRecord::Base
  include DmUniboCommon::User

  validates :email, presence: {}
  validates :email, uniqueness: {}

  has_and_belongs_to_many :courses
  # has_many :courses_users
  # has_many :courses, :through => :courses_users
  has_many :changelogs
  has_many :packages, :through => :changelogs

  def is_admin?
    self.admin
  end

  def ==(another_user)
    self.id == another_user.id
  end
end


