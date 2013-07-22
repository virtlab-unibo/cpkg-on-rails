class Corepackage < ActiveRecord::Base
  has_many   :changelogs
  has_many   :documents
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

  # FIXME: we should re-use the code in the module not rewrite
  # the entire method just cause: self.class.where in the module
  def depends_on
    if self.depends
      self.depends.split(', ').inject([]) do |res, name|
        if p = Package.where(:name => name.split(/ /)[0]).first
          res << p
        else
          logger.info("No package #{name.split(/ /)[0]} for #{self.depends} in #{self.inspect}")
        end 
        res 
      end 
    else
      []  
    end 
  end 

  def script_content type 
    s = get_script type
    if s
      File.open(s, 'r'){|file| file.readlines.join("")}
    else
      ""
    end
  end

  def prerm
    script_content :prerm
  end

  def preinst
    script_content :preinst
  end

  def postrm
    script_content :postrm
  end

  def postinst
    script_content :postinst
  end

    
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

