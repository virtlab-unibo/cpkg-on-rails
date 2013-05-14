class CoursesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  attr_accessible :owner_flag
 end


