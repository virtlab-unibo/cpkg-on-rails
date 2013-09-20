require 'fileutils'
require 'tmpdir'

namespace :cpkg do
  namespace :fs_core_package do
    desc "Updates fs core package"
    task :update => :environment do
      begin
        Dir.mktmpdir do |tmp_dir|
          # copy debian directory template.
          puts "copying debain directory template"
          FileUtils.cp_r(File.expand_path(File.join(Rails.root, "config", "debian")), tmp_dir)
          # copy filesystem global hierarchy.
          puts "copying filesystem global hierarchy"
          global_path = File.expand_path(File.join(Rails.root, "packages", "global"))
          files_list = Dir.glob("#{global_path}/**/*").select {|f| not File.directory? f}
          # building the install file
          install = ""
          files_list.each do |f|
            fkroot_path = f.split("global")[1]
            install += "#{File.basename(fkroot_path)} #{File.dirname(fkroot_path)}\n"
            FileUtils.cp(f, tmp_dir)
          end
          # writing the changelog and control file
          name = "vlab-fs-core"
          version = Time.new.strftime("%Y%m%d-%H")
          date = Time.new.strftime("%a, %d %b %Y %H:%M:%S %z")

          chlog = """#{name} (#{version}) precise; urgency=low

  * Updated manually from rake script 

 -- VirtLab Team <support@virtlab.unibo.it>  #{date}"""

          control = """Priority: optional
Section: vlab
Build-Depends: debhelper (>= 7)
Maintainer: VirtLab Team <support@virtlab.unibo.it>
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
          key = "-k" + Rails.configuration.gpg_key 
          stdout = `dpkg-buildpackage -rfakeroot #{key} 2>&1`
          puts stdout
          # move the generated files into the incoming folder of the repo
          if $?.success?
            FileUtils.mv(Dir.glob(File.join("..", "#{name}_#{version}")+"*"), 
                         Rails.configuration.repo_dir, :force => true)
          end
        end
      rescue => err 
        puts "An error has occured: #{err}"
      end

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

