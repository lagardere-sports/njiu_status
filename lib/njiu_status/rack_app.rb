module NjiuStatus
  class RackApp
    def self.checks
      @checks ||= {}
    end

    def self.add_check(name:, handler:, options: {})
      checks["/#{name}"] = handler
    end

    def self.call(env)
      request = Rack::Request.new env
      response = Rack::Response.new
      check = checks[request.path_info]
      if check
        check.call(request, response)
      else
        response.write "{error: unknown check: '#{request.path_info}'}"
        response.status = 404
      end
      response.finish
    end
  end
end
