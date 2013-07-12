class Corepackage < ActiveRecord::Base
  has_many   :changelogs
  has_many   :scripts
  has_many   :users, :through => :changelogs
  has_and_belongs_to_many :courses

  acts_as_debian_package :section      => 'vlab-admin',
                         :maintainer   => "Unibo Virtlab",
                         # FIXME maybe other mail or maybe configurable by user
                         :email        => Rails.configuration.support_mail, 
                         :gpg_key     => Rails.configuration.gpg_key

  #attr_accessible :name, :short_description, :long_description, :depends, :homepage, :documents, :version, :filename

  validates_uniqueness_of :name, :message => :package_name_duplication
  validates_presence_of :name
 #FIXME: temporary commented out. MATTIA 12/07/13
 # scope :ours,  -> { where('course_id IS NOT NULL') }
  # has to be executed before the validation process to 
  # make sure che correct package name is going to be validated
 # before_validation :init_name, :on => :create

  #before_create :init_dependencies, 
  #              :generate_homepage

  # automatically generated home page. See homepage_base in configuration
 # def generate_homepage
 #   Rails.configuration.homepage_base or return true
 #   self.homepage ||= (Rails.configuration.homepage_base + "/#{self.name}")
 # end

  def get_description
    self.short_description.blank? ? I18n.t(:no_description) : self.short_description
  end

 # def init_dependencies
 #   unless self.course.nil?
 #     self.depends = self.core_dep
 #   end
 # end

#  def init_name
#    unless self.course.nil?
#      self.name = "#{self.course.degree.code}-#{self.course.abbr}-#{self.name}"
#    end
#  end

end

