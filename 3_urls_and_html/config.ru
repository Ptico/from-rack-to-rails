$LOAD_PATH.unshift(File.dirname(__FILE__)) # Add current directory to load paths

require 'rack'
require 'railz'

run Railz.new