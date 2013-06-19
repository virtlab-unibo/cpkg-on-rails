class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  #has_many :courses_users
  #has_many :users, :through => :courses_users
  has_many :packages
  belongs_to :degree

  validates_presence_of :name, :year, :degree_id, :abbr
  validates_uniqueness_of :name
  validates_format_of :abbr, :with => /\A[a-z0-9][a-z0-9+.-]+\z/, :message => :course_name_format

  def to_s
    self.degree.code + "-" + self.name
  end

end
