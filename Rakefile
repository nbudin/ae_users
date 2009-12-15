require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the ae_users plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for Illyan.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Illyan'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "illyan"
    gemspec.summary = "Instant authentication, authorization, and SSO for Rails"
    gemspec.description = <<EOD
Illyan is an out-of-the-box setup for authentication, authorization, and (optionally)
single sign-on.  Rather than reinventing the wheel, Illyan uses popular and proven
solutions: Devise for authentication, acl9 for authorization, and CAS for single
sign-on.
EOD
    gemspec.email = "natbudin@gmail.com"
    gemspec.homepage = "http://github.com/nbudin/ae_users"
    gemspec.authors = ["Nat Budin"]
    gemspec.add_dependency('acl9')
    gemspec.add_dependency('devise')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
