class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :degree
  has_many :vlab_packages, dependent: :restrict_with_error

  validates_presence_of :name, :year, :degree_id, :abbr
  validates :name, presence: true, uniqueness: true
  validates :abbr, format: { with: /\A[a-z0-9][a-z0-9+.-]+\z/, message: :course_name_format },
                   length: { in: 2..10 },
                   uniqueness: true

  before_destroy :verify_no_dependencies

  def to_s
    self.degree.code + "-" + self.name
  end
 
  def verify_no_dependencies
    if self.vlab_packages.any?
      self.errors.add(:base, 'There are packages. Please delete them before deleting the course.')
      return false
    end
  end

  def description_to_s
    self.description.blank? ? I18n.t(:no_description) : self.description
  end
end
