# archivio da cui si scaricano i packages
class Archive < ActiveRecord::Base
  # FIXME
  # has_many :packages, :dependent => :destroy
  has_many :packages

  attr_accessible :uri, :distribution, :component, :arch

  acts_as_apt_source

  def self.default_attributes
    { :uri          => 'http://mi.mirror.garr.it/mirrors/debian/',
      :distribution => 'stable', 
      :component    => 'main', 
      :arch         => 'binary-i386' }
  end

end



