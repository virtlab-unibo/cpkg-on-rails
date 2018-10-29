class VlabPackage < Package
  belongs_to :course
  has_many   :documents, dependent: :destroy, foreign_key: 'package_id'
  has_many   :scripts, dependent: :destroy
  has_many   :users, through: :changelogs

  validates :name, presence: true, uniqueness: { message: :package_name_duplication }

  # has to be executed before the validation process to 
  # make sure che correct package name is going to be validated
  before_validation :init_name, on: :create

  before_create  :generate_homepage
  before_save    :add_global_deps
  before_destroy :verify_no_dependencies

  # automatically generated home page. See homepage_base in configuration
  def generate_homepage
    Rails.configuration.homepage_base or return true
    self.homepage ||= (Rails.configuration.homepage_base + "/#{self.name}")
  end

  # Adds global dependencies defined in the config file if not already present.
  # only in local packages (without archive_id)
  def add_global_deps
    self.archive_id and return

    complete_depends = (self.depends || '').split(', ') + Rails.configuration.global_deps.split(', ')
    self.depends = complete_depends.uniq.join(', ')

    #if self.depends
    #  deps_l = self.depends.split(", ")
    #  Rails.configuration.global_deps.split(",").each do |gdep| 
    #    (self.depends += ", #{gdep.strip}") unless deps_l.include? gdep.strip
    #  end
    #else
    #  self.depends = Rails.configuration.global_deps
    #end
  end

  def name_prefix
    if self.course.nil?
      "undef-course"
    else
      "#{self.course.degree.code}-#{self.course.abbr}"
    end
  end

  def init_name
    self.name = "#{self.name_prefix}-#{self.name}"
  end

  def verify_no_dependencies
    if self.documents.any?
      self.errors.add(:base, 'There are documents')
      return false
    end
  end
end

