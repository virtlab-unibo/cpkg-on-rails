require 'fileutils'

namespace :cpkg do
  namespace :core_package do
    desc "Updates core package of course"
    task :update_core_package => :environment do
      course_name = ENV['course'] or raise "I need the name of the course"
      course = Course.find(course_name)

      FileUtils.cp_r(File.expand_path(File.join(Rails.root, "config", "debian")), tmp_dir)

    end
  end
end

