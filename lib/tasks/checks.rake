namespace :cpkg do
  namespace :checks do
    desc "Check packages"
    task packages: :environment do
      Course.find_each do |course|
        course.vlab_packages.each do |package|
          package.depends.split(', ').inject([]) do |res, name|
            Package.where(name: name.split(/ /)[0]).first and next
            puts "No package #{name.split(/ /)[0]} for #{package.depends} in #{package.inspect}"
          end
        end
      end
    end
  end
end

