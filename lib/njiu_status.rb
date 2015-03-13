require "njiu_status/version"
require "njiu_status/constants"
require "njiu_status/configuration"
require "njiu_status/check"
require "njiu_status/rack_app"

module NjiuStatus
  def self.configure
    yield(Configuration)
  end

  def self.config
    Configuration
  end

  def self.checks
    Check.all
  end

  def self.add_check(*args)
    Check.add *args
  end
end
