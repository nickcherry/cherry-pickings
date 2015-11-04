require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl_rails'
require 'rspec/rails'
require 'shoulda/matchers'

Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 5

RSpec.configure do |config|

  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  config.filter_run_excluding(category: :benchmark)
  config.order = 'random'
  config.raise_errors_for_deprecations!
  config.use_transactional_fixtures = true

end
