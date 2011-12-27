HelloWorld.routes = Railz::Routes.new do |map|
  map.get  "/posts", controller: PostsController, action: "index"
  map.post "/posts", controller: PostsController, action: "create"

  map.get  "/users", controller: UsersController, action: "index"
  map.post "/users", controller: UsersController, action: "create"
end