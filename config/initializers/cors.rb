# https://ricostacruz.com/til/rails-and-cloudfront
# http://thelazylog.com/correct-configuration-to-fix-cors-issue-with-cloudfront/

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    # This resource list should be compatible with the assets in cloudfront.rb
    resource '/assets/*', headers: :any, methods: [:get]
    resource '/fonts/*', headers: :any, methods: [:get]
    resource '/images/*', headers: :any, methods: [:get]
    resource '/vendor/*', headers: :any, methods: [:get]
  end
end
