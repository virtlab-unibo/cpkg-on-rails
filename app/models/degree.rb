class Degree < ActiveRecord::Base
  has_many :courses

  def to_s
    self.name
  end

  def to_s_with_code
    self.code + " " + self.name
  end
end

