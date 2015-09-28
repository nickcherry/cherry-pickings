group :spec, halt_on_fail: true do
  guard :rspec, cmd: 'rspec' do
    watch('Gemfile')
    watch('spec/rails_helper.rb')                       { 'spec' }
    watch('spec/rails_helper_lite.rb')                  { 'spec' }
    watch('spec/rake_helper.rb')                        { 'spec/lib/tasks' }
    watch(%r{^spec/support/(.+)\.rb$})                  { 'spec' }
    watch('config/routes.rb')                           { 'spec/routing' }
    watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
    watch('app/controllers/authenticated_controller.rb'){ 'spec/controllers' }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rake$})                         { |m| "spec/lib/#{m[1]}_spec.rb" }
  end
end
