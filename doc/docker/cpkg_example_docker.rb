# Be sure to restart your server when you modify this file.
CpkgOnRails::Application.configure do
  ADMINS = ['name.surnam@example.com']

  config.omniauth_default = :google
  config.project_link = { name: 'Virlab home page', url: 'http://virtlab.unibo.it/' }
  config.login_icon = 'ssologo18x18.png'
  config.logout_icon = 'ssologo18x18.png'
  config.support_mail = 'support@virtlab.unibo.it'
  config.action_mailer.default_url_options = { host: 'tester.dm.unibo.it/cpkg', protocol: 'https' }
  # config.homepage_proc = lambda {|p| "https://www.virtlab.unibo.it/cpkg/#{p.name}"},
  # if not nil each package has a home page as http://homepage_base/#{package.name}
  config.homepage_base = "https://www.virtlab.unibo.it/cpkg"
  # Location to store packages created to be downloaded 
  config.tmp_packages_dir = "/var/www/tmp/packages"

  config.i18n.default_locale = :it
  # the gpg key-id of the gpg key you want to use to sign packages.
  # leave an empty string if you don't want to sign them.
  config.gpg_key = "09A0DEDE"

  # Global dependencies. A comma-separaed list of packages that will be 
  # added to every package created with cpkg.
  config.global_deps = "vlab-core"

  # Default email inserted into the packages creared by cpkg.
  config.support_email = "admin@cpkg.it"
  # Default section which the packages will be part of.
  config.pkgs_default_section = "vlab"
  # Default maintainer
  config.pkgs_default_maintainer = "Cpkg Admin"
  # Distribution code name. This value is a field of the debian package.
  config.linux_distro = "stretch"

  config.reprepro_confdir     = Rails.root.join("reprepro/conf")
  config.reprepro_basedir     = "/var/www/repo"
  config.reprepro_incomingdir = Rails.root.join("reprepro/incoming")
  # FIXME
  File.open(config.reprepro_confdir.join('incoming'), "w") do |f|
    f.puts "Name: #{config.linux_distro}"
    f.puts "IncomingDir: #{config.reprepro_incomingdir}"
    f.puts "Cleanup: on_deny on_error"
    f.puts "TempDir: /tmp"
    f.puts "Default: #{config.linux_distro}"
  end 
  # reprepro_command = 'reprepro -v --confdir /home/rails/cpkg-on-rails/reprepro/conf --basedir /var/www/repo processincoming stretch'
  config.reprepro_command = "/usr/bin/reprepro"
  config.reprepro_exec = "#{config.reprepro_command} -v --confdir #{config.reprepro_confdir} --basedir #{config.reprepro_basedir} #{config.linux_distro}"

  # List of content types allowed to be uploaded and inserted into a package
  config.content_types = ['application/x-tar', 'application/zip', 'application/x-zip-compressed', 'application/pdf', 'text/plain', 'image/jpeg', 'image/png'] 
  Paperclip.options[:content_type_mappings] = { pdf: [ "application/pdf", "binary/octet-stream" ], tex: [ "application/x-tex", "text/plain" ] }

  config.domain_name     = 'example.com'
  config.header_title    = 'CpkgOnRails'
  config.header_subtitle = 'Package manager for VirtLab courses'
  config.header_icon     = 'suitcase' 

  # see config/dm_unibo_common.yml
  config.dm_unibo_common.update(
      login_method: :log_and_create,
      message_footer: %Q{Messaggio inviato da 'CpkgOnRails'.\nNon rispondere a questo messaggio.},
      impersonate_admins: [],
      interceptor_mails: [] 
  )
end



