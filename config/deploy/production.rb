set :stage, :production
set :rails_env, 'production'
key_path = '~/.ssh/capistrano'
server '192.168.179.9', roles: %w(web app db),
                        user: 'deploy',
                        ssh_options: {
                          user: 'deploy',
                          keys: key_path,
                          auth_methods: %w(publickey)
                        }
