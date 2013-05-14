class Degree < ActiveRecord::Base
  has_many :courses

  attr_accessible :code, :name, :as => :admin

  def to_s
    self.name
  end
end

