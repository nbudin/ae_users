ENV["RAILS_ENV"] = "test"
require File.join(File.dirname(__FILE__), 'rails_app', 'config', 'environment')
 
require 'test_help'
require 'webrat'
require 'mocha'
 
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
 
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'
 
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

Dir["#{File.dirname(__FILE__)}/../generators/*/templates/*.rb"].each {|f| require f}
AeUsersLocalTables.up
 
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end
 
class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end
