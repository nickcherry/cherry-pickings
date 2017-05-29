require 'katex'
require 'nokogiri'
require 'rouge/plugins/redcarpet'

module Renderers
  class PostBodyHtmlRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def postprocess(doc)
      [
        :emojify, # Emojification should come before URL resolution
        :katexify,
        :resolve_link_paths,
        :resolve_css_paths,
        :resolve_img_and_script_paths,
      ].reduce(nokogirify(doc)) { |doc, process| send(process, doc) }.to_s
    end

  protected

    # Protected: Initializes HTML string as Nokogiri HTML instance
    def nokogirify(doc)
      Nokogiri::HTML.fragment(doc)
    end

    # Protected: Replace emoji characters (e.g. ':squirrel:') with emoji images
    def emojify(doc)
      doc_as_string = doc.to_s.gsub(/:([\w+-]+):/) do |match|
        emoji = Emoji.find_by_alias($1)
        emoji ? emoji_template(emoji) : match
      end
      nokogirify(doc_as_string)
    end

    # Protected: Returns template for emoji image
    def emoji_template(emoji)
      path = helpers.image_path("emoji/#{ emoji.image_filename }")
      %(<img class="emoji #{ emoji.name }-emoji"
          src="#{ path }" />)
    end

    # Protected: Convert all link paths absolute URLs
    def resolve_link_paths(doc)
      doc.tap do |doc|
        doc.css('a').each do |node|
          href = node['href']
          if href && !is_absolute?(href)
            node['href'] = app_base_url + single_leading_slash(href)
          end
        end
      end
    end

    # Protected: Convert all css asset paths to absolute (Cloudfront) URLs
    def resolve_css_paths(doc)
       doc.tap do |doc|
        doc.css('link').each do |node|
          href = node['href']
          if href && !is_absolute?(href)
            node['href'] = asset_base_url + single_leading_slash(href)
          end
        end
      end
    end

    # Protected: Convert all img and script asset paths to absolute (Cloudfront) URLs
    def resolve_img_and_script_paths(doc)
      doc.tap do |doc|
        doc.css('img,script').each do |node|
          src = node['src']
          if src && !is_absolute?(src)
            node['src'] = asset_base_url + single_leading_slash(src)
          end
        end
      end
    end

    # Protected: Replace Katex characters (e.g. \frac{\sum{y} - m(\sum{x})}{n}) with HTML equivalent
    def katexify(doc)
      doc.tap do |doc|
        doc.css('.cp-katex').each do |node|
          node.inner_html = Katex.render(node.content)
        end
      end
    end

    # Protected: Returns ActionController helpers, necessary for generating asset paths
    def helpers
      ActionController::Base.helpers
    end

    # Protected: Returns root URL, necessary for resolving relative link paths to absolute URLs
    def app_base_url
      @app_base_url ||= URI::HTTP.build(
        Rails.application.config.action_controller.default_url_options
      ).to_s
    end

    # Protected: Returns asset root URL, necessary for resolving relative asset paths to absolute URLs
    def asset_base_url
      @asset_url ||= Rails.application.config.action_controller.asset_host
    end

    # Protected: Ensures that provided string has a single leading slash
    def single_leading_slash(str)
      first_non_slash_index = str.index /[^\/]/
      '/' + str.slice(first_non_slash_index, str.size)
    end

    # Protected: Determines whether a given path is absolute
    def is_absolute?(path)
      path =~ /^(?:[a-z]+:)?\/\//
    end
  end
end
