require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "-c", "-f progress", "-r test/spec/spec_helper.rb"]
  t.pattern = 'test/spec/**/*_spec.rb'  
end

desc 'Translate this gem'
task :translate do
  file = File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')
  system("babelphish -o -y #{file}")
  path = File.join(File.dirname(__FILE__), 'app', 'views', 'user_mailer')
  system("babelphish -o -h #{path} -l en")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "muck-users"
    gem.summary = "Easy to use user engine for Rails"
    gem.email = "justin@tatemae.com"
    gem.homepage = "http://github.com/jbasdf/muck_users"
    gem.description = "Easily add user signup, login and other features to your application"
    gem.authors = ["Justin Ball", "Joel Duffin"]
    gem.rubyforge_project = "muck-users"
    gem.add_dependency "authlogic"
    gem.add_dependency "bcrypt-ruby"
    gem.add_dependency "muck-engine", ">=3.0.3"
    gem.add_dependency "friendly_id"
    gem.test_files.exclude 'test/**' # exclude test directory
  end
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test/lib'
    t.pattern = 'test/spec/**/*_spec.rb'
    t.verbose = true
    t.output_dir = 'coverage'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "muck-users #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

