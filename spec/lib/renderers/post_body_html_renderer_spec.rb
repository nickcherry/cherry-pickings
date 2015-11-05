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

    it 'should render basic markdown' do
      markdown = "# Greetings!\n\nWelcome to the test suite."
      html = %r{<h1>Greetings!</h1><p>Welcome to the test suite.</p>}
      assert markdown, html
    end

    it 'should render emojis' do
      markdown = ":chicken:"
      html = %r{<p><img class="emoji chicken-emoji" alt="chicken" src="http://.*\.png" /></p>}
      assert markdown, html
    end

    it 'should resolve links to absolute URLS' do
      markdown = "<a href='/first'>First</a><a href=\"/second\">Second</a>"
      html = %r{<p><a href='#{ base_url }/first'>First</a><a href="#{ base_url }/second">Second</a></p>}
      assert markdown, html
    end

  end
end
