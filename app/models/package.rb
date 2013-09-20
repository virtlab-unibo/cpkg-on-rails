class Package < ActiveRecord::Base
  belongs_to :course
  belongs_to :archive
  has_many   :documents
  has_many   :changelogs
  has_many   :scripts
  has_many   :users, :through => :changelogs

  acts_as_debian_package :section      => Rails.configuration.pkgs_default_section,
                         :maintainer   => Rails.configuration.pkgs_default_maintainer,
                         # FIXME maybe other mail or maybe configurable by user
                         :email        => Rails.configuration.support_mail, 
                         :gpg_key     => Rails.configuration.gpg_key

  #attr_accessible :name, :short_description, :long_description, :depends, :homepage, :documents, :version, :filename

  validates_uniqueness_of :name, :message => :package_name_duplication
  validates_presence_of :name

  scope :ours,  -> { where('course_id IS NOT NULL') }
  # has to be executed before the validation process to 
  # make sure che correct package name is going to be validated
  before_validation :init_name, :on => :create

  before_create :add_global_deps,
                :generate_homepage

  # automatically generated home page. See homepage_base in configuration
  def generate_homepage
    Rails.configuration.homepage_base or return true
    self.homepage ||= (Rails.configuration.homepage_base + "/#{self.name}")
  end

  # Adds global dependencies defined in the config file
  # if not already present.
  def add_global_deps
    if self.depends
      deps_l = self.depends.split(", ")
      Rails.configuration.global_deps.split(",").each do |gdep| 
        (self.depends += ", #{gdep.strip}") unless deps_l.include? gdep.strip
      end
    else
      self.depends = Rails.configuration.global_deps
    end
  end

  def get_description
    self.short_description.blank? ? I18n.t(:no_description) : self.short_description
  end

  def init_name
    unless self.course.nil?
      self.name = "#{self.course.degree.code}-#{self.course.abbr}-#{self.name}"
    end
  end

end

