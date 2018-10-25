class Package < ActiveRecord::Base
  belongs_to :course
  belongs_to :archive, optional: true
  has_many   :documents, dependent: :destroy
  has_many   :scripts, dependent: :destroy
  has_many   :changelogs, dependent: :destroy
  has_many   :users, through: :changelogs

  acts_as_debian_package section: Rails.configuration.pkgs_default_section,
                         maintainer: Rails.configuration.pkgs_default_maintainer,
                         # FIXME maybe other mail or maybe configurable by user
                         email: Rails.configuration.support_mail, 
                         gpg_key: Rails.configuration.gpg_key

  #attr_accessible :name, :short_description, :long_description, :depends, :homepage, :documents, :version, :filename

  validates :name, presence: true, uniqueness: { message: :package_name_duplication }

  scope :ours,  -> { where('course_id IS NOT NULL') }
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

  def get_description
    self.short_description.blank? ? I18n.t(:no_description) : self.short_description
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

  def webid
    "pkg_#{self.id}"
  end

end

