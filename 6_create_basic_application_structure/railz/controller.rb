module Railz
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
end