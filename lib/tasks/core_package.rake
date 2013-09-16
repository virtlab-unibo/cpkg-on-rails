require 'fileutils'
require 'tmpdir'

namespace :cpkg do
  namespace :fs_core_package do
    desc "Updates core package of course"
    task :update_core_package => :environment do
      course_id = ENV['course'] or raise "I need the name of the course"
      begin
        course = Course.find(course_id)
        Dir.mktmpdir do |tmp_dir|
          
          # copy debian directory template.
          puts "copying debain directory template"
          FileUtils.cp_r(File.expand_path(File.join(Rails.root, "config", "debian")), tmp_dir)
          deb_dir =  File.join(tmp_dir, "debian")
          # copy filesystem global hierarchy.
          puts "copying filesystem global hierarchy"
          FileUtils.cp_r(File.expand_path(File.join(Rails.root, "packages", "global") + "/"), deb_dir)
          # copy filesystem course hierarchy and overwrite existing files.
          puts "copying filesystem local hierarchy"
          course_dir = File.expand_path(File.join(Rails.root, "packages", course.name))
          if Dir.exists? course_dir 
            FileUtils.cp_r(course_dir, deb_dir)
          end

          puts "executing dpkg-buildpackage" 
          # TODO: create package
          # FIXME FIXME FIXME FIXME FIXME
          Dir.chdir (tmp_dir)
          puts Dir.entries("./debian")
          key = "" #FIXME set global gpg key
          stdout = `dpkg-buildpackage -rfakeroot #{key} 2>&1`
          puts $?.success?
          # FIXME FIXME FIXME FIXME FIXME
          # TODO: move to repo
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

