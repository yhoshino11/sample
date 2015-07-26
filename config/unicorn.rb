# -*- coding: utf-8 -*-
# worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
# timeout 15
# preload_app true  # 更新時ダウンタイム無し

# listen '/tmp/unicorn.sock'
# pid '/tmp/unicorn.pid'

# before_fork do |server, worker|
  # Signal.trap 'TERM' do
    # puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    # Process.kill 'QUIT', Process.pid
  # end

  # defined?(ActiveRecord::Base) &&
    # ActiveRecord::Base.connection.disconnect!
# end

# after_fork do |server, worker|
  # Signal.trap 'TERM' do
    # puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  # end

  # defined?(ActiveRecord::Base) &&
    # ActiveRecord::Base.establish_connection
# end

# ログの出力
# stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
# stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])


app_path = File.dirname(File.dirname(Dir.pwd))

worker_processes 4

working_directory "#{app_path}/current"

listen "#{app_path}/shared/tmp/sockets/unicorn.sock", backlog: 64

timeout 60

pid "#{app_path}/shared/tmp/pids/unicorn.pid"

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

# Gemfile を変更したときにも読み込まれるようにする。 see: http://qiita.com/tachiba/items/7eef03cce6a917a957dc
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  # Occasionally, it may be necessary to run non-idempotent code in the
  # master before forking.  Keep in mind the above disconnect! example
  # is idempotent and does not need a guard.
  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  # old_pid = "#{server.config[:pid]}.oldbin"
  # if old_pid != server.pid
  #   begin
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
  #     Process.kill(sig, File.read(old_pid).to_i)
  #   rescue Errno::ENOENT, Errno::ESRCH
  #   end
  # end
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
