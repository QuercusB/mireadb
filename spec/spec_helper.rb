require 'rubygems'
require 'spork'

Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers'
  require 'rspec/its'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }
  
  ActiveRecord::Migration.maintain_test_schema!

  RSpec.configure do |config|

    config.use_transactional_fixtures = true
    config.infer_spec_type_from_file_location!
    
    config.include Devise::TestHelpers, type: :controller
    
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with :truncation
    end
    
    config.before(:each) do
      DatabaseCleaner.start
    end
    
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

end

Spork.each_run do
  FactoryGirl.reload
  # This code will be run each time you run your specs.
  Dir[Rails.root + "app/models/*.rb"].each do |file|
    load file
  end  
end
