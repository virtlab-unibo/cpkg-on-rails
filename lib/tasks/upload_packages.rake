namespace :cpkg do
  namespace :packages do
    desc "Upload packages"
    task upload_all: :environment do

      admin = User.first_admin
      VlabPackage.find_each do |package|
        changelog = package.changelogs.new(user_id: admin.id, description: 'automatic upload') 
        changelog.save!
        package.reload
        equivs = ActiveDebianRepository::Equivs.new(package, Rails.configuration.reprepro_incomingdir)
        equivs.create!
        `#{Rails.configuration.reprepro_exec}`
      end
    end
  end
end


