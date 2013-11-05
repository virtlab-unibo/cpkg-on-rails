module ApplicationHelper

  def icon(name, options = { :text => "", :size => "18" })
    "<i style=\"font-size: #{options[:size]}px\" class=\"icon icon-#{name.to_s}\"></i> #{options[:text]}".html_safe
  end

  def logout_link
    dest = case Rails.configuration.omniauth_default 
           when :shibboleth
             Rails.env.production? ? 'https://idp.unibo.it/adfs/ls/Prelogout.aspx' : 'https://idptest.unibo.it/adfs/ls/Prelogout.aspx'
           when :google
             logout_path
           end
    link_to (image_tag(Rails.configuration.login_icon) + ' <strong>Logout</strong>'.html_safe), dest
  end

end
