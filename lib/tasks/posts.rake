require 'find'

namespace :posts do

  desc '(Re-)Render body html for all posts'
  task :render => :environment do
    Post.all.each(&:save)
  end

  desc 'Sync database posts with markdown posts found in db/posts'
  task :sync => :environment do

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

      body_markdown = File.read(filepath).gsub(/---(.|\n)*---/, '').strip

      puts "Finding or creating post with public_id: #{ public_id }"
      post = Post.find_or_create_by(public_id: public_id)

      puts "...title: #{ title }"
      post.title = title
      puts "...tags: #{ tags.join(', ') }"
      post.tags = tags.map {|tag_name| Tag.find_or_create_by(name: tag_name) }
      puts "...image: #{ image }"
      post.image = image
      puts "...published: #{ published }"
      post.published = published
      puts "...body_markdown: #{ body_markdown }"
      post.body_markdown = body_markdown

      post.save!

    end
  end

end
