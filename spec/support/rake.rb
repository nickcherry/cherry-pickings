require 'rake'

RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_tasks
  end
end

def rake(command, *args)
  task = Rake::Task[command]
  task.reenable
  task.invoke *args
end
