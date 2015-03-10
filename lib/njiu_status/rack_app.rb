require "json"

module NjiuStatus
  class RackApp
    def self.call(env)
      request = Rack::Request.new env
      response = Rack::Response.new

      token = request.params["token"] || (env["HTTP_AUTHORIZATION"] && env["HTTP_AUTHORIZATION"].split.last)
      if !Configuration.token.nil? && Configuration.token != token
        response.write({error: "token invalid or missing"}.to_json)
        response.status = 401
      else
        format = File.extname(request.path_info)
        action = File.path(request.path_info).chomp(format)
        check = Check.all[action]
        if check
          begin
            check.call(request, response)
          rescue => e
            response.write({error: "#{e.class}: #{e.message}"}.to_json)
            response.status = 500
          end
        else
          response.write({error: "unknown check: '#{action}'"}.to_json)
          response.status = 404
        end
      end
      response.finish
    end
  end
end
