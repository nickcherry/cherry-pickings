require 'rouge/plugins/redcarpet'

module Renderers
  class PostBodyHtmlRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
    include Rails.application.routes.url_helpers

    def postprocess(document)
      document.gsub!(/:([\w+-]+):/) do |match|
        if emoji = Emoji.find_by_alias($1)
          emoji_template(emoji)
        else
          match
        end
      end
    end

    def emoji_template(emoji)
      path = ActionController::Base.helpers.image_path "emoji/#{ emoji.image_filename }"
      %(<img class="emoji #{ emoji.name }-emoji"
          alt="#{ emoji.name }"
          src="#{ path }"
      />)
    end
  end
end
