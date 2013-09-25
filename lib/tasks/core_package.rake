require 'fileutils'
require 'tmpdir'

namespace :cpkg do

  namespace :core_package do
    desc "Updates core package. Is mandatory to pass name=$PKG-NAME as argument."
    task :update => :environment do
      begin
        Dir.mktmpdir do |tmp_dir|
          if not ENV.include? "name"
            puts "ERROR: we need a name"
            return
          end
          name = ENV['name']
          pkg_path = File.join(Rails.root, "packages", name)
          # copy debian directory template.
          puts "copying debian directory template"
          FileUtils.cp_r(File.expand_path(File.join(pkg_path, "debian")), tmp_dir)
          # copy filesystem global hierarchy.
          puts "copying filesystem global hierarchy"
          global_path = File.expand_path(File.join(pkg_path, "fs"))
          files_list = Dir.glob("#{global_path}/**/*").select {|f| not File.directory? f}
          # building the install file
          install = ""
          files_list.each do |f|
            fkroot_path = f.split("global")[1]
            install += "#{File.basename(fkroot_path)} #{File.dirname(fkroot_path)}\n"
            FileUtils.cp(f, tmp_dir)
          end
          # writing the changelog and control file
          version = Time.new.strftime("%Y%m%d-%H")
          date = Time.new.strftime("%a, %d %b %Y %H:%M:%S %z")
          rc = Rails.configuration

          chlog = """#{name} (#{version}) #{rc.linux_distro}; urgency=low

  * Updated manually from rake script 

 -- #{rc.pkgs_default_maintainer} <#{rc.support_mail}>  #{date}"""

          control = """Priority: optional
Section: #{rc.pkgs_default_section} 
Build-Depends: debhelper (>= 7)
Maintainer: #{rc.pkgs_default_maintainer} <#{rc.support_mail}>
Standards-Version: 3.9.2
Source: #{name}

Package: #{name}
Architecture: all
Description: This is a corepackage of the Virtlab Project.
 This is a corepackage of the Virtlab Project.
"""
          puts "executing dpkg-buildpackage" 
          Dir.chdir (tmp_dir)
          File.open("debian/install", 'w+') { |file| file.write(install) }
          File.open("debian/control", 'w+') { |file| file.write(control) }
          File.open("debian/changelog", 'w+') { |file| file.write(chlog) }
          key = "-k" + rc.gpg_key 
          stdout = `dpkg-buildpackage -rfakeroot #{key} 2>&1`
          puts stdout
          # move the generated files into the incoming folder of the repo
          if $?.success?
            FileUtils.mv(Dir.glob(File.join("..", "#{name}_#{version}")+"*"), 
                         rc.repo_dir, :force => true)
          end
        end
      rescue => err 
        puts "An error has occured: #{err}"
      end

    end

    desc "Create the directory structure for a corepackage. name=$PKG_NAME param is mandatory."
    task :create => :environment do
      if not ENV.include? "name"
        puts "ERROR: we need a name"
        return
      end
      name = ENV["name"]
      pkg_path = File.join(Rails.root, "packages", name)
      if File.exists?(pkg_path)
        puts "ERROR: A directory named #{name} already exists."
        return
      end

      FileUtils.mkdir_p File.join(pkg_path, "fs")
      FileUtils.cp_r(File.expand_path(File.join(Rails.root, "config", "debian")), pkg_path)

    end

  end

  namespace :courses do
    desc "courses"
    task :list => :environment do
      Course.find(:all).each do |course|
        puts "ID: #{course.id}, Name: #{course.name}"
      end
    end
  end
end
