require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/rbenv'
set :rbenv_custom_path, '/home/deploy/.rbenv'
set :rbenv_ruby, '2.1.6'
set :deploy_to, '/home/deploy/sample'
set :scm, :git
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
