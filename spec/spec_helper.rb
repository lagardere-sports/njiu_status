require "bundler/setup"
Bundler.setup

require "njiu_status"
require "rack/test"
require "byebug"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = :random
end
