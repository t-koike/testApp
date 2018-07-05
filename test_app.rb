require "rubygems"
require "sinatra/base"
require "securerandom"
require 'date'
require "dalli"

class TestApp < Sinatra::Base

  memcached_server = "192.168.128.3:11221"
  test_times = "1000"

  get '/' do
    "I am live!"
  end

  get '/test' do
    sleep(3)
    a =  (1..1000).to_a.map{|x| SecureRandom.hex(8)}
    a.sort
  end

  get '/test2' do
    start = Time.now()
    while(1) do
      t = Time.now()
      break if t - start > 1
    end

    d = SecureRandom.hex(1024)
    "Hello, test app! " + d
  end

  get '/test3' do
    dalli = Dalli::Client.new(memcached_server)
    data = Array.new(1024).map { rand(0..255) }.pack("c*")
    d = SecureRandom.hex(32)
    test_times.to_i.times do
      dalli.set(d, data)
      dalli.get(d)
      sleep(0.01)
    end

    "test3 api! id = " + d
  end

end
