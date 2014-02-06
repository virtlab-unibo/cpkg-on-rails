namespace :cpkg do
  namespace :users do
    desc "Creation of user"
    task :create_user => :environment do
      print "Provide e-mail of the user: "
      email = STDIN.gets.chomp

      u = User.new(:upn => email, :email => email)
      u.save!
    end

    desc "Creation of amdin user"
    task :create_admin_user => :environment do
      print "Provide e-mail of the admin user: "
      email = STDIN.gets.chomp

      u = User.new(:upn => email, :email => email)
      u.admin = 1
      u.save!
    end
  end
end

