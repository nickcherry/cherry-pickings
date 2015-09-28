namespace :posts do

  desc '(Re-)Render body html for all posts'
  task :render => :environment do
    Post.all.each(&:save)
  end

end
