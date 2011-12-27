require 'rack'

class Railz
  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    @response.status = 200
    @response['Content-Type'] = 'text/html'
    @response.body   = @request.params.map{ |k, v| "#{k}=#{v}" }

    @response.finish
  end
end

run Railz.new