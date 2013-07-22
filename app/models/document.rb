# has_attached_file:
#   url: The default value is “/system/:class/:attachment/:id_partition/:style/:filename”.
#
class Document < ActiveRecord::Base
  belongs_to :package
  belongs_to :corepackage

  validates_attachment_presence :attach

  validates_uniqueness_of :attach_file_name, :scope => :package_id, 
                          :message => "Il File non e' stato uploadato. Il nome del file deve essere univoco nel pacchetto." 

  validates_presence_of   :name, :message => "Si prega di assegnare un nome al documento allegato" 
  validates_uniqueness_of :name, :scope => :package_id,
                          :message => "Il File non e' stato uploadato. Il nome del file deve essere univoco nel pacchetto." 

  #Paperclip 3.0 introduces a non-backward compatible change in your attachment
  #path. This will help to prevent attachment name clashes when you have
  #multiple attachments with the same name. If you didn't alter your
  #attachment's path and are using Paperclip's default, you'll have to add
  #`:path` and `:url` to your `has_attached_file` definition. For example:
  #has_attached_file :avatar,
  #    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  #    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :attach

  # in questo modo possiamo mettere :upn nel path del document
  #Paperclip.interpolates :upn do |att, style|
    # paperclip attachments i quali hanno come instance il document a cui sono allegati
    # att.instance.user.upn
  # end

  # url  = da dove si scarica (creato in config/routes)
  # path = dove si salva il file
  # rack_base_uri = ENV["RACK_BASE_URI"] || ''
  # has_attached_file :attach,
  #                   :url  => rack_base_uri + "/documents/:id/download",
  #                   :path => ":rails_root/files/:upn/:filename"

  def to_s
    self.description.blank? ? self.attach_file_name : self.description
  end

  # see https://github.com/tors/jquery-fileupload-rails-paperclip-example app/models/upload.rb
  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:attach_file_name),
      "size" => read_attribute(:attach_file_size),
      "url" => attach.url(:original),
      "delete_url" => document_path(self),
      "delete_type" => "DELETE" 
    }
  end


end

