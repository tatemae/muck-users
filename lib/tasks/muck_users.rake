namespace :muck do
  
  namespace :sync do
    desc "Sync files from muck users."
    task :users do
      path = File.join(File.dirname(__FILE__), *%w[.. ..])
      system "rsync -ruv #{path}/db ."
      system "rsync -ruv #{path}/public ."
    end
  end
  
  namespace :users do
    desc "Setup default admin user"
    task :create_admin => :environment do
      ['administrator', 'manager', 'editor', 'contributor'].each {|r| Role.create(:rolename => r) }
      user = User.new
      user.login = "admin"
      user.email = MuckEngine.configuration.admin_email
      user.password = "asdfasdf"
      user.password_confirmation = "asdfasdf"
      user.first_name = "Administrator"
      user.last_name = "Administrator"
      user.save
      user.activate!

      user.add_to_role('administrator')

      puts 'created admin user'
    end
  end
  
end
