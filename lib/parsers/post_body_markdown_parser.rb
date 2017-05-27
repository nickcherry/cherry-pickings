require 'redcarpet'
require 'rouge'

module Parsers
  class PostBodyMarkdownParser < Redcarpet::Markdown
    def self.new(renderer, extensions={})
      super renderer, extensions.reverse_merge(
        autolink: true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        quote: true,
        strikethrough: true
      )
    end
  end
end
