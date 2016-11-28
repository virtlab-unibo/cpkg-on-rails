class Degree < ActiveRecord::Base
  has_many :courses

  validates :name, uniqueness: true

  def to_s
    self.name
  end

  def to_s_with_code
    self.code + " " + self.name
  end
end

