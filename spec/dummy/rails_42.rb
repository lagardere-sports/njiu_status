require "rails"
require "action_controller/railtie"

class Rails42 < Rails::Application
  config.secret_key_base = "secret_key_base"

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
  response.write "4.2.0"
end
