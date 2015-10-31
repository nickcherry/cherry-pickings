require 'find'

namespace :posts do

  desc '(Re-)Render body html for all posts'
  task :render => :environment do
    Post.all.each(&:save)
  end

  desc 'Sync database posts with markdown posts found in db/posts'
  task :sync => :environment do

    dir = File.join(Rails.root, 'db', 'posts')
    matcher = /(\.md|\.markdown)$/i

    Find.find(dir).select{|filepath| matcher =~ filepath }.each do |filepath|

      yaml = YAML.load_file(filepath).deep_symbolize_keys

      internal_id = yaml[:internal_id]
      title = yaml[:title]
      tags = yaml[:tags] || []
      published = yaml[:published]

      body_markdown = File.read(filepath).gsub(/---(.|\n)*---/, '').strip

      puts "Finding or creating post with internal_id: #{ internal_id }"
      post = Post.find_or_create_by(internal_id: yaml[:internal_id])

      puts "...title: #{ title }"
      post.title = title
      puts "...tags: #{ tags.join(', ') }"
      post.tags = tags.map {|tag_name| Tag.find_or_create_by(name: tag_name) }
      puts "...published: #{ published }"
      post.published = published
      puts "...body_markdown: #{ body_markdown }"
      post.body_markdown = body_markdown

      post.save!

    end
  end

end
