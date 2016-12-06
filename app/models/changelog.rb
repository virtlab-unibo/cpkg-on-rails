class Changelog < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  acts_as_debian_changelog

  validates_presence_of :package_id, :user_id

  before_create :increment_version
  after_create  :update_package_version

  # version is date-ver (20120703-3)
  def increment_version
    old_version = Changelog.where(package_id: self.package_id).maximum(:version)
    now_date = Date.today.to_s.split("-").join # 20120703
    counter = 1

    if old_version
      old_date, counter = old_version.split("-")
      counter = (now_date == old_date) ? (counter.to_i + 1) : 1
    end

    self.version = "#{now_date}-#{counter}"
  end

  def update_package_version
    self.package.update_column(:version, self.version)
  end

end


