module Railz
  class Routes
    def initialize(&block)
      @routes = {
        get:  {},
        post: {},
        put:  {},
        delete: {}
      }

      block.call(self)

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
end