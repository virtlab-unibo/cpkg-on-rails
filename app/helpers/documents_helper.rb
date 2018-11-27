module DocumentsHelper
  def document_icon(document)
    c = case document.attach_content_type 
    when 'application/pdf'
      'fas fa-file-pdf '
    when 'application/zip'
      'fas fa-file-archive'
    when 'text/plain'
      'fas fa-file-alt'
    when 'image/jpeg', 'image/png'
      'fas fa-image'
    when 'audio/mpeg'
      'fas fa-file-audio'
    when 'text/x-python'
      'fab fa-python'
    when 'text/html'
      'fab fa-html5'
    else
      'fas fa-file'
    end
    content_tag(:i, '', style: "font-size: 35px", class: c)
  end
end

