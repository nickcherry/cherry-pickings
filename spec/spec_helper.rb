require File.expand_path('../../config/environment', __FILE__)
require 'capybara/rspec'
require 'database_cleaner'
require 'factory_girl_rails'
require 'rspec/rails'
require 'shoulda/matchers'

Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 5

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.raise_errors_for_deprecations!

  config.filter_run_excluding(category: :benchmark)

  config.order = 'random'

  config.include Devise::TestHelpers, type: :controller

  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
