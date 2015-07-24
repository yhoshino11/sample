application = 'reserve-hacker'
worker_processes 2
app_path = '/sample'
listen "#{app_path}/shared/tmp/sockets/unicorn.sock"
pid "#{app_path}/current/tmp/unicorn.pid"
timeout 60
preload_app true
stdout_path "#{app_path}/current/log/production.log"
stderr_path "#{app_path}/current/log/production.log"
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true
