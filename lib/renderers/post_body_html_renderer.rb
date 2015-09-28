require 'rouge/plugins/redcarpet'

module Renderers
  class PostBodyHtmlRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
