$LOAD_PATH.unshift(File.dirname(__FILE__)) # Add current directory to load paths

require 'rack'
require 'railz/application'
require 'app/boot'

run HelloWorld.new