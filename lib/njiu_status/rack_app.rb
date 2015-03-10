module NjiuStatus
  class RackApp
    def self.call(env)
      request = Rack::Request.new env
      response = Rack::Response.new
      check = Check.all[request.path_info]
      if check
        check.call(request, response)
      else
        response.write "{error: 'unknown check: #{request.path_info}'}"
        response.status = 404
      end
      response.finish
    end
  end
end
