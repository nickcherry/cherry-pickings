# http://ricostacruz.com/til/rails-and-cloudfront

# Middleware to deny CloudFront requests to non-assets
class CloudfrontDenier
  def initialize(app, options = {})
    @app = app
    @target = options[:target] || '/'
  end

  def call(env)
    if cloudfront?(env) && !asset?(env)
      [302, { 'Location' => @target }, []]
    else
      @app.call(env)
    end
  end

  def asset?(env)
    env['PATH_INFO'] =~ %r{^/assets}
  end

  def cloudfront?(env)
    env['HTTP_USER_AGENT'] == 'Amazon CloudFront'
  end
end

Rails.application.config.middleware.use CloudfrontDenier,
  target: 'http://www.nick-cherry.com/'
