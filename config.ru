require "rubygems"
require "sinatra"

require File.expand_path '../test_app.rb', __FILE__

use Raindrops::Middleware
run TestApp
