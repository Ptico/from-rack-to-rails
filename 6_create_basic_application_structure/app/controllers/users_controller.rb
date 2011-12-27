class UsersController < Railz::BaseController
  def index
    render "Users here!", status: 200
  end

  def create
    render "Create user"
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
          <h2>Param-param</h2>
        </body>
      </html>
    EOF
  end
end