require 'rack'

class Railz
  def call(env)
    code    = 200 # HTTP response code
    headers = {"Content-Type" => "text/plain"} # HTTP response headers
    body    = env.map{ |k, v| "#{k}=#{v}" }.join("\n") # Response body

    [code, headers, [body]]
  end
end

run Railz.new