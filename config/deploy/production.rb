set :stage, :production
set :rails_env, 'production'
server '192.168.179.9', user: 'root', roles: %w(web app db)
set :ssh_options, keys: [File.expand_path('~/.ssh/id_rsa)')]

# server 'example.com', user: 'deploy', roles: %w{app db web},
# server 'example.com', user: 'deploy', roles: %w{app web}
# server 'db.example.com', user: 'deploy', roles: %w{db}

# role :app, %w{deploy@example.com}
# role :web, %w{user1@primary.com user2@additional.com}
# role :db,  %w{deploy@example.com}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
