class CorepackagesCourse < ActiveRecord::Base
  belongs_to :corepackage
  belongs_to :course
end
