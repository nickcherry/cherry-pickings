namespace :deploy do

  def deploy(force=false)
    app = 'cherry-pickings'
    remote = "git@heroku.com:#{ app }.git"

    system "git push #{ remote } master #{ force ? '--force' : '' }"
    system "heroku run rake db:migrate --app #{ app }"
    system "heroku run rake posts:sync --app #{ app }"
    system "heroku run rake sitemap:refresh --app #{ app }"
  end

  desc 'Deploy to Heroku'
  task :production do
    deploy
  end

  desc 'Deploy to Heroku with force'
  task :force_production do
    deploy(true)
  end

end
