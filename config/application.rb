require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CherryPickings
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib')

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    Rails.application.config.assets.precompile += [
      'KaTeX_AMS-Regular.eot',
      'KaTeX_AMS-Regular.ttf',
      'KaTeX_AMS-Regular.woff',
      'KaTeX_AMS-Regular.woff2',
      'KaTeX_Caligraphic-Bold.eot',
      'KaTeX_Caligraphic-Bold.ttf',
      'KaTeX_Caligraphic-Bold.woff',
      'KaTeX_Caligraphic-Bold.woff2',
      'KaTeX_Caligraphic-Regular.eot',
      'KaTeX_Caligraphic-Regular.ttf',
      'KaTeX_Caligraphic-Regular.woff',
      'KaTeX_Caligraphic-Regular.woff2',
      'KaTeX_Fraktur-Bold.eot',
      'KaTeX_Fraktur-Bold.ttf',
      'KaTeX_Fraktur-Bold.woff',
      'KaTeX_Fraktur-Bold.woff2',
      'KaTeX_Fraktur-Regular.eot',
      'KaTeX_Fraktur-Regular.ttf',
      'KaTeX_Fraktur-Regular.woff',
      'KaTeX_Fraktur-Regular.woff2',
      'KaTeX_Main-Bold.eot',
      'KaTeX_Main-Bold.ttf',
      'KaTeX_Main-Bold.woff',
      'KaTeX_Main-Bold.woff2',
      'KaTeX_Main-Italic.eot',
      'KaTeX_Main-Italic.ttf',
      'KaTeX_Main-Italic.woff',
      'KaTeX_Main-Italic.woff2',
      'KaTeX_Main-Regular.eot',
      'KaTeX_Main-Regular.ttf',
      'KaTeX_Main-Regular.woff',
      'KaTeX_Main-Regular.woff2',
      'KaTeX_Math-Italic.eot',
      'KaTeX_Math-Italic.ttf',
      'KaTeX_Math-Italic.woff',
      'KaTeX_Math-Italic.woff2',
      'KaTeX_SansSerif-Regular.eot',
      'KaTeX_SansSerif-Regular.ttf',
      'KaTeX_SansSerif-Regular.woff',
      'KaTeX_SansSerif-Regular.woff2',
      'KaTeX_Script-Regular.eot',
      'KaTeX_Script-Regular.ttf',
      'KaTeX_Script-Regular.woff',
      'KaTeX_Script-Regular.woff2',
      'KaTeX_Size1-Regular.eot',
      'KaTeX_Size1-Regular.ttf',
      'KaTeX_Size1-Regular.woff',
      'KaTeX_Size1-Regular.woff2',
      'KaTeX_Size2-Regular.eot',
      'KaTeX_Size2-Regular.ttf',
      'KaTeX_Size2-Regular.woff',
      'KaTeX_Size2-Regular.woff2',
      'KaTeX_Size3-Regular.eot',
      'KaTeX_Size3-Regular.ttf',
      'KaTeX_Size3-Regular.woff',
      'KaTeX_Size3-Regular.woff2',
      'KaTeX_Size4-Regular.eot',
      'KaTeX_Size4-Regular.ttf',
      'KaTeX_Size4-Regular.woff',
      'KaTeX_Size4-Regular.woff2',
      'KaTeX_Typewriter-Regular.eot',
      'KaTeX_Typewriter-Regular.ttf',
      'KaTeX_Typewriter-Regular.woff',
      'KaTeX_Typewriter-Regular.woff2',
    ]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use Rack::Deflater # Enable gzipping

    config.generators do |g|
       g.template_engine :erb
       g.test_framework  :rspec, :fixture => true, :views => false
       g.integration_tool :rspec, :fixture => true, :views => true
       g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

  end
end
