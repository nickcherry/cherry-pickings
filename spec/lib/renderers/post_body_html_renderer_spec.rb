require 'rails_helper'

RSpec.describe Renderers::PostBodyHtmlRenderer do

  let(:parser) { Parsers::PostBodyMarkdownParser.new(renderer) }
  let(:renderer) { Renderers::PostBodyHtmlRenderer.new }

  def normalize_html(str)
    str.gsub("\n", '').squeeze(' ')
  end

  def assert(markdown, html)
    expect(normalize_html(parser.render(markdown))).to match html
  end

  describe 'render' do
    let(:app_host) { 'http://fake-app-host:1234' }
    let(:default_url_options) {{ protocol: 'http', host: 'fake-app-host', port: '1234' }}
    let(:asset_host) { 'http://fake-asset-host' }

    around do |example|
      real_asset_host = Rails.application.config.action_controller.asset_host
      real_default_url_options = Rails.application.config.action_controller.default_url_options
      Rails.application.config.action_controller.asset_host = asset_host
      Rails.application.config.action_controller.default_url_options = default_url_options
      example.run
      Rails.application.config.action_controller.asset_host = real_asset_host
      Rails.application.config.action_controller.default_url_options = real_default_url_options
    end

    it 'should render basic markdown' do
      markdown = "# Greetings!\n\nWelcome to the test suite."
      html = %r{<h1>Greetings!</h1><p>Welcome to the test suite.</p>}
      assert markdown, html
    end

    it 'should render emojis' do
      markdown = ":chicken:"
      html = %r{<p><img class="emoji chicken-emoji" src="http://.*\.png"></p>}
      assert markdown, html
    end

    it 'should render katex' do
      markdown = "<div><span class='cp-katex inline'>b = \frac{\sum{y} - m(\sum{x})}{n}</span></div>"
      html = "<div><span class=\"cp-katex inline\"><span class=\"katex\"><span class=\"katex-mathml\"><math><semantics><mrow><mi>b</mi><mo>=</mo><mi>r</mi><mi>a</mi><mi>c</mi><mrow><mi>u</mi><mi>m</mi><mrow><mi>y</mi></mrow><mo>−</mo><mi>m</mi><mo>(</mo><mi>u</mi><mi>m</mi><mrow><mi>x</mi></mrow><mo>)</mo></mrow><mrow><mi>n</mi></mrow></mrow><annotation encoding=\"application/x-tex\">b = rac{ um{y} - m( um{x})}{n}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"strut\" style=\"height:0.75em;\"></span><span class=\"strut bottom\" style=\"height:1em;vertical-align:-0.25em;\"></span><span class=\"base textstyle uncramped\"><span class=\"mord mathit\">b</span><span class=\"mrel\">=</span><span class=\"mord mathit\" style=\"margin-right:0.02778em;\">r</span><span class=\"mord mathit\">a</span><span class=\"mord mathit\">c</span><span class=\"mord textstyle uncramped\"><span class=\"mord mathit\">u</span><span class=\"mord mathit\">m</span><span class=\"mord textstyle uncramped\"><span class=\"mord mathit\" style=\"margin-right:0.03588em;\">y</span></span><span class=\"mbin\">−</span><span class=\"mord mathit\">m</span><span class=\"mopen\">(</span><span class=\"mord mathit\">u</span><span class=\"mord mathit\">m</span><span class=\"mord textstyle uncramped\"><span class=\"mord mathit\">x</span></span><span class=\"mclose\">)</span></span><span class=\"mord textstyle uncramped\"><span class=\"mord mathit\">n</span></span></span></span></span></span></div>"
      assert markdown, html
    end

    it 'should resolve relative links to absolute URLs' do
      markdown = "<a href='/first'>First</a><a href=\"/second\">Second</a>"
      html = %r{<p><a href="#{ app_host }/first">First</a><a href="#{ app_host }/second">Second</a></p>}
      assert markdown, html
    end

    it 'should not resolve absolute paths' do
      markdown = '<a href="https://google.com">Some Other Site</a>'
      html = '<a href="https://google.com">Some Other Site</a>'
      assert markdown, html
    end

    it 'should resolve relative asset paths to absolute URLs' do
      markdown = [
        "<script src='/vendor.js'></script>",
        "<link rel='stylesheet' type='text/css' href=\"vendor.css\">",
        "<img src=\"/vendor.png\">"
      ].join
      html = [
        "<p>",
        "<script src=\"#{ asset_host }/vendor.js\"></script>",
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{ asset_host }/vendor.css\">",
        "<img src=\"#{ asset_host }/vendor.png\">",
        "</p>"
      ].join
      assert markdown, html
    end

    it 'should not resolve absolute asset paths' do
      markdown = [
        "<script src='https://google.com/vendor.js'></script>",
        "<link rel='stylesheet' type='text/css' href=\"https://google.com/vendor.css\">",
        "<img src=\"https://google.com/vendor.png\">"
      ].join
      html = [
        "<p>",
        "<script src=\"https://google.com/vendor.js\"></script>",
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://google.com/vendor.css\">",
        "<img src=\"https://google.com/vendor.png\">",
        "</p>"
      ].join
      assert markdown, html
    end
  end
end
