require 'rouge/plugins/redcarpet'

module Renderers
  class PostBodyHtmlRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def postprocess(document)
      emojify(document)
      resolve_links(document)
    end

  protected

    # Protected: Convert all anchor and image paths to absolute URLs
    def resolve_links(document)
      document.gsub!(/<(?:a[^>]+href|img[^>]+src)=["'](\/)/) do |match|
        match.chomp('/') + base_url + '/'
      end
    end

    # Protected: Replace emoji characters (e.g. ':squirrel:') with emoji images
    def emojify(document)
      document.gsub!(/:([\w+-]+):/) do |match|
        emoji = Emoji.find_by_alias($1)
        emoji ? emoji_template(emoji) : match
      end
    end

    # Protected: Returns template for emoji image
    def emoji_template(emoji)
      path = helpers.image_path "emoji/#{ emoji.image_filename }"
      %(<img class="emoji #{ emoji.name }-emoji"
          alt="#{ emoji.name }"
          src="#{ path }" />)
    end

    # Protected: Returns ActionController helpers, necessary for generating asset paths
    def helpers
      ActionController::Base.helpers
    end

    # Protected: Returns root URL, necessary for resolving relative paths to absolute URLs
    def base_url
      @base_url ||= URI::HTTP.build(
        Rails.application.config.action_controller.default_url_options
      ).to_s
    end

  end
end
