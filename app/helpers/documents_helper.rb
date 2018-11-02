module DocumentsHelper
  def document_icon(document)
    icon(case document.attach_content_type 
    when 'application/pdf'
      'file-pdf'
    when 'application/zip'
      'file-archive'
    when 'text/plain'
      'file-alt'
    when 'image/jpeg', 'image/png'
      'image'
    when 'audio/mpeg'
      'file-audio'
    else
      'file'
    end, size: 50)
  end
end

