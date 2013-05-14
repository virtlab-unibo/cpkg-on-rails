module ApplicationHelper

  def icon(name, options = { :text => "", :size => "18" })
    "<i style=\"font-size: #{options[:size]}px\" class=\"icon icon-#{name.to_s}\"></i> #{options[:text]}".html_safe
  end
end
