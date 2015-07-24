set :application, 'Capistrano Test'
set :repo_url, 'https://github.com/yhoshino11/sample.git'
set :branch, 'master'
set :deploy_to, '/sample'
set :keep_releases, 1
set :rbenv_type, :user
set :rbenv_ruby, '2.1.6'
set :rbenv_map_bins, %w(rake gem bundle ruby rails)
set :rbenv_roles, :all
set :linked_dirs, %w(bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle)

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
