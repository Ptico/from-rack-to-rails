class PostsController < Railz::BaseController
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