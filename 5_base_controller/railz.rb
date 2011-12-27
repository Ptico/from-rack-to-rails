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

class BaseController
  def initialize(request, response)
    @request  = request
    @response = response
    @rendered = false
  end

  def send_action(name)
    self.send(name.to_sym) # Call real action

    render unless @rendered

    @response
  end

private

  def params
    @request.params
  end

  def render(body, options={})
    raise "Double render error" if @rendered

    @response.status = options[:status] || 200
    @response.body   = [html(body || "")]

    (options[:headers] || {"Content-Type" => 'text/html'}).each_pair do |k, v|
      @response[k] = v
    end

    @rendered = true
  end
end

class PostsController < BaseController
  def index
    render "Listing #{params['user'] || 'ptico'}'s posts:"
  end

  def create
    render "Create post"
  end

private

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

    begin
      @response = route[:controller].new(@request, @response).send_action(route[:action])
    rescue
      @response.body    = ["Not found"]
      @response.status  = 404
      @response["Content-Type"] = 'text/html'
    end
  end
end