ActiveSupport::Dependencies.load_once_paths << lib_path

if config.respond_to?(:gems)
  config.gem "authlogic"
else
  begin
    require 'authlogic'
  rescue LoadError
    begin
      gem 'authlogic'
    rescue Gem::LoadError
      puts "Please install the authlogic gem"
    end
  end
end

if config.respond_to?(:gems)
  config.gem "searchlogic"
else
  begin
    require 'searchlogic'
  rescue LoadError
    begin
      gem 'searchlogic'
    rescue Gem::LoadError
      puts "Please install the searchlogic gem"
    end
  end
end

require 'muck_users'
require 'muck_users/initialize_routes'
