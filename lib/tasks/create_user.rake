namespace :cpkg do
  namespace :users do
    desc "Creation of user"
    task :create_user => :environment do
      print "Provide e-mail of the user: "
      email = STDIN.gets.chomp
      print "Provide upn of the user(default=[]): "
      upn = STDIN.gets.chomp

      u = User.new(:upn => upn, :email => email)
      u.save!
    end

    desc "Creation of amdin user"
    task :create_admin_user => :environment do
      print "Provide e-mail of the admin user: "
      email = STDIN.gets.chomp
      print "Provide the upn of the admin user(default=[]): "
      upn = STDIN.gets.chomp

      u = User.new(:upn => upn, :email => email)
      u.admin = 1
      u.save!
    end
  end
end

