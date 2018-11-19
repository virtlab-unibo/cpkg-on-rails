class Document < ActiveRecord::Base
  belongs_to :vlab_package, foreign_key: 'package_id'

  validates :attach, attachment_presence: true
  validates :attach_file_name, uniqueness: { scope: :package_id, message: "Il File non è stato uploadato. Il nome del file deve essere univoco nel pacchetto." }
  validates :name, presence: { message: "Si prega di assegnare un nome al documento allegato" },
                   uniqueness: { scope: :package_id, message: "Il File non è stato uploadato. Il nome del file deve essere univoco nel pacchetto." }

  has_attached_file :attach, 
                    path: ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename",
                    url: "#{ENV["RACK_BASE_URI"]}/system/:class/:attachment/:id_partition/:style/:filename"

  # Validate content type
  # validates_attachment_content_type :attach, content_type: Rails.configuration.content_types 
  do_not_validate_attachment_file_type :attach

  # in questo modo possiamo mettere :upn nel path del document
  #Paperclip.interpolates :upn do |att, style|
    # paperclip attachments i quali hanno come instance il document a cui sono allegati
    # att.instance.user.upn
  # end

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

  def install_path
    File.join(Rails.configuration.vlab_files_basedir, self.vlab_package.course.abbr, self.vlab_package.name)
  end
end

