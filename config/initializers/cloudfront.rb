# http://ricostacruz.com/til/rails-and-cloudfront
# http://thelazylog.com/correct-configuration-to-fix-cors-issue-with-cloudfront/

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
    env['PATH_INFO'] =~ %r{/assets/|/fonts/|/images/|/vendor/}
  end

  def cloudfront?(env)
    env['HTTP_USER_AGENT'] == 'Amazon CloudFront'
  end
end

Rails.application.config.middleware.use CloudfrontDenier,
  target: Settings.app.url
