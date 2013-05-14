class Course < ActiveRecord::Base
  #has_and_belongs_to_many :users
  has_many :courses_users
  has_many :users, :through => :courses_users
  has_many :packages
  belongs_to :degree

  attr_accessible :name, :degree_id, :abbr, :description, :year, :user_ids, :as => :admin

  validates_presence_of :name, :year, :degree_id, :abbr
  validates_uniqueness_of :name
  validates_format_of :abbr, :with => /^[a-z0-9][a-z0-9+.-]+$/, :message => :course_name_format

  def to_s
    self.degree.code + "-" + self.name
  end

  def get_owner
    owner = nil
    courses_users.each do |cusers|
      if cusers.owner_flag
        owner = cusers.user
      end
    end
    return owner
  end
 
end


