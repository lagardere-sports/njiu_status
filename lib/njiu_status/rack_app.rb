module NjiuStatus
  class RackApp
    def self.call(env)
      request = Rack::Request.new env
      response = Rack::Response.new

      if !Configuration.token.nil? && Configuration.token != request.params["token"]
        response.write "{error: 'token invalid or missing'}"
        response.status = 401
      else
        check = Check.all[request.path_info]
        if check
          check.call(request, response)
        else
          response.write "{error: 'unknown check: #{request.path_info}'}"
          response.status = 404
        end
      end
      response.finish
    end
  end
end
