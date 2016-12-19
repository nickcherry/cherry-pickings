ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl_rails'
require 'rspec/rails'
require 'shoulda/matchers'

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5
Capybara.server_port = 9876

RSpec.configure do |config|

  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  config.filter_run_excluding(category: :benchmark)
  config.infer_spec_type_from_file_location!
  config.order = 'random'
  config.raise_errors_for_deprecations!
end
