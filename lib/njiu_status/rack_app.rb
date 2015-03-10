require "json"

module NjiuStatus
  class RackApp
    def self.call(env)
      request = Rack::Request.new env
      response = Rack::Response.new

      if !Configuration.token.nil? && Configuration.token != request.params["token"]
        response.write({error: "token invalid or missing"}.to_json)
        response.status = 401
      else
        format = File.extname(request.path_info)
        action = File.path(request.path_info).chomp(format)
        check = Check.all[action]
        if check
          check.call(request, response)
        else
          response.write({error: "unknown check: '#{action}'"}.to_json)
          response.status = 404
        end
      end
      response.finish
    end
  end
end
