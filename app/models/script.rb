# Paperclip::Attachment.default_options[:validate_media_type] = false

class Script < ActiveRecord::Base
  include Paperclip::Glue
  belongs_to :vlab_package, foreign_key: 'package_id'

  validates_format_of :stype, with: /^(preinst|postinst|prerm|postrm)$/, message: :script_type_unknown, multiline: true

  has_attached_file :attach, path: "#{File.dirname(__FILE__)}:url"
  do_not_validate_attachment_file_type :attach

  def to_s
    self.attach_file_name
  end 

  def content
    %q[#!/bin/bash

]
  end

  def Script.types
    [:preinst, :prerm, :postinst, :postrm]
  end

end
