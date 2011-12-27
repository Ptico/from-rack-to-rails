class Routes
  def initialize(&block)
    @routes = {
      get:  {},
      post: {},
      put:  {},
      delete: {}
    }

    block.call(self) # Call methods from block

    self
  end

  def get(path, options={})
    @routes[:get][path] = options
  end

  def post(path, options={})
    @routes[:post][path] = options
  end

  def process!(request)
    meth = request.request_method.downcase.to_sym
    @routes[meth][request.path_info]
  end
end

class PostsController
  def index
    ["Listing posts", 200]
  end

  def create
    ["Create post", 200]
  end
end

class Railz
  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    process_request

    @response.finish
  end

  def process_request
    routes = Routes.new do |map| # Here: map == routes.self
      map.get  "/posts", controller: PostsController, action: "index"
      map.post "/posts", controller: PostsController, action: "create"
    end

    route = routes.process!(@request)

    title, status = begin
      route[:controller].new.send(route[:action].to_sym)
    rescue
      ["Not found", 404]
    end

    @response.status = status
    @response.body   = [html(title)]
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