class Degree < ActiveRecord::Base
  has_many :courses

  def to_s
    self.name
  end
end

