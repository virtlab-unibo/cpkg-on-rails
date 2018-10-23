namespace :cpkg do
  namespace :checks do
    desc "Check packages"
    task packages: :environment do
      Course.find_each do |course|
        course.packages.each do |package|
          p package
          package.depends_on.each do |dep|
            dep.name or raise package.inspect
          end
        end
      end
    end
  end
end

