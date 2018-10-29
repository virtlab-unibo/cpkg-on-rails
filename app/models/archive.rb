# archivio da cui si scaricano i packages
class Archive < ActiveRecord::Base
  has_many :packages, dependent: :destroy
  has_many :vlab_packages

  acts_as_apt_source

  def self.default_attributes
    { uri:          'http://mi.mirror.garr.it/mirrors/debian/',
      distribution: 'stretch', 
      component:    'main', 
      arch:         'binary-amd64' }
  end

end



