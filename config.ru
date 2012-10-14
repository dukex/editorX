require 'bundler'
Bundler.require

require './app'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => :get
  end
end


use EditorX
run Catapult.app
