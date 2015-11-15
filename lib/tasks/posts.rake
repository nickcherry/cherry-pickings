require 'find'

namespace :posts do

  desc '(Re-)Render body html for all posts'
  task :render => :environment do
    Post.all.each(&:save)
  end

  desc 'Sync database posts with markdown posts found in db/posts'
  task :sync => :environment do

    def log(message)
      puts(message) unless Rails.env.test?
    end

    dir = if markdown_path = ENV['markdown_path']
      File.join Rails.root, markdown_path
    else
      File.join(Rails.root, 'db', 'posts')
    end

    matcher = /(\.md|\.markdown)$/i

    Find.find(dir).select{|filepath| matcher =~ filepath }.each do |filepath|

      yaml = YAML.load_file(filepath).deep_symbolize_keys

      public_id = yaml[:public_id]
      title = yaml[:title]
      tags = yaml[:tags] || []
      published = yaml[:published]
      image = yaml[:image]

      body_markdown = File.read(filepath).gsub(/^---(.|\n)*---$/, '').strip

      log "Finding or creating post with public_id: #{ public_id }"
      post = Post.find_or_create_by(public_id: public_id)

      post.title = title
      post.tags = tags.map {|tag_name| Tag.find_or_create_by(name: tag_name) }
      post.image = image
      post.published = published
      post.body_markdown = body_markdown

      log "Saving post:"
      log "...title: #{ title }"
      log "...tags: #{ tags.join(', ') }"
      log "...image: #{ image }"
      log "...published: #{ published }"
      log "...body_markdown: #{ body_markdown }"

      post.save!

    end
  end

end
