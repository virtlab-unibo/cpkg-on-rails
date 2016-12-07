class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :packages
  belongs_to :degree

  validates_presence_of :name, :year, :degree_id, :abbr
  validates_uniqueness_of :name
  validates_format_of :abbr, :with => /\A[a-z0-9][a-z0-9+.-]+\z/, :message => :course_name_format

  before_destroy :verify_no_dependencies

  def to_s
    self.degree.code + "-" + self.name
  end
 
  def verify_no_dependencies
    if self.packages.any?
      self.errors.add(:base, 'There are packages')
      return false
    end
  end

end
