# -*- encoding: utf-8 -*-
root_path = File.expand_path '../', File.dirname(__FILE__)
log_file = root_path + '/log/unicorn.log'
err_log  = root_path + '/log/unicorn_error.log'
pid_file = '/tmp/test_app.pid'
old_pid = pid_file + '.oldbin'
socket_file = '/tmp/test_app.sock'

worker_processes 96

working_directory root_path
timeout 60

listen 8080, tcp_nopush: true
listen socket_file, backlog: 2048

pid pid_file
stderr_path err_log
stdout_path log_file

preload_app true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = root_path + '/Gemfile'
end

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      puts "#{Time.now} Sending #{sig} signal to old unicorn master..."
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => exception
      puts "#{Time.now} #{exception.message}"
    end
  end
  sleep 1
end
