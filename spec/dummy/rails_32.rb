require "rails"
require "action_controller/railtie"

class Rails32 < Rails::Application
  config.secret_token = "secret_token"*3

  config.logger = Logger.new("/dev/null")
  Rails.logger = config.logger

  routes.draw do
    mount NjiuStatus::RackApp, at: "status"
  end
end

NjiuStatus.configure do |config|
  config.token = nil
end

NjiuStatus.add_check name: "rails_version", handler: -> (request, response) do
  response.write "3.2.21"
end
