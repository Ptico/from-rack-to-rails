require 'railz/controller'
require 'railz/routes'

module Railz
  class Application
    def self.routes=(routes)
      @@routes = routes
    end

    def call(env)
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new

      process_request

      @response.finish
    end

    def process_request
      route = @@routes.process!(@request)

      begin
        @response = route[:controller].new(@request, @response).send_action(route[:action])
      rescue
        @response.body    = ["Not found"]
        @response.status  = 404
        @response["Content-Type"] = 'text/html'
      end
    end
  end
end