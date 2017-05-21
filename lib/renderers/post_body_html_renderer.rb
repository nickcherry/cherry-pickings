require 'rouge/plugins/redcarpet'

module Renderers
  class PostBodyHtmlRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def postprocess(document)
      [
        :emojify, # Emojification should come before URL resolution
        :resolve_link_paths,
        :resolve_asset_paths
      ].reduce(document) do |document, process|
        send process, document
      end
    end

  protected

    # Protected: Convert all link paths absolute URLs
    def resolve_link_paths(document)
      document.gsub(/<(?:a[^>]+href)=["'](\/)/) do |match|
        match.chomp('/') + base_url + '/'
      end
    end

    # Protected: Convert all asset paths to absolute (Cloudfront) URLs
    def resolve_asset_paths(document)
      document.gsub(/<(?:img[^>]+src|link[^>]+href|script[^>]+src)=["'](\/)/) do |match|
        match.include?(asset_base_url) ? match : match.chomp('/') + asset_base_url + '/'
      end
    end

    # Protected: Replace emoji characters (e.g. ':squirrel:') with emoji images
    def emojify(document)
      document.gsub(/:([\w+-]+):/) do |match|
        emoji = Emoji.find_by_alias($1)
        emoji ? emoji_template(emoji) : match
      end
    end

    # Protected: Returns template for emoji image
    def emoji_template(emoji)
      path = helpers.image_path("emoji/#{ emoji.image_filename }")
      %(<img class="emoji #{ emoji.name }-emoji"
          src="#{ path }" />)
    end

    # Protected: Returns ActionController helpers, necessary for generating asset paths
    def helpers
      ActionController::Base.helpers
    end

    # Protected: Returns root URL, necessary for resolving relative link paths to absolute URLs
    def base_url
      @base_url ||= URI::HTTP.build(
        Rails.application.config.action_controller.default_url_options
      ).to_s
    end

    # Protected: Returns asset root URL, necessary for resolving relative asset paths to absolute URLs
    def asset_base_url
      @asset_url ||= Rails.application.config.action_controller.asset_host
    end

  end
end
