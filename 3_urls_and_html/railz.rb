class Railz
  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    process_request

    @response.finish
  end

  def process_request
    case @request.path_info
      when '/'
        @response.status = 200
        @response.body   = [html("Index")]
      when '/hello'
        @response.status = 200
        @response.body   = [html("Hello world")]
      else
        @response.status = 404
        @response.body   = [html("Not found")]
    end
    @response['Content-Type'] = 'text/html'
  end

  def html(title)
    <<-EOF
      <html>
        <head>
          <title>#{title}</title>
        </head>
        <body>
          <h1>#{title}</h1>
          Params:
          <ul>
            #{ @request.params.map{ |k, v| "<li>#{k} = #{v}</li>"}.join("\n") }
          </ul>
        </body>
      </html>
    EOF
  end
end