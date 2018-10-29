class Package < ActiveRecord::Base
  belongs_to :archive, optional: true
  has_many   :changelogs, dependent: :destroy

  acts_as_debian_package section: Rails.configuration.pkgs_default_section,
                         maintainer: Rails.configuration.pkgs_default_maintainer,
                         # FIXME maybe other mail or maybe configurable by user
                         email: Rails.configuration.support_mail, 
                         gpg_key: Rails.configuration.gpg_key,
                         search_class_name: 'Package'

  #attr_accessible :name, :short_description, :long_description, :depends, :homepage, :documents, :version, :filename

  validates :name, presence: true, uniqueness: { message: :package_name_duplication }

  scope :ours,  -> { where('course_id IS NOT NULL') }

  def get_description
    self.short_description.blank? ? I18n.t(:no_description) : self.short_description
  end

  def webid
    "pkg_#{self.id}"
  end

end

