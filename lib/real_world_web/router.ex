defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug(Guardian.Plug.Pipeline, module: RealWorldWeb.Guardian, error_handler: RealWorldWeb.AuthErrorHandler)
    plug(Guardian.Plug.VerifyHeader, realm: "Token")
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  scope "/", RealWorldWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    get("/user", UserController, :show)
    put("/user", UserController, :update)
    post("/users/login", SessionController, :create)

    get("/profiles/:username", ProfileController, :show)
    post("/profiles/:username/follow", ProfileController, :follow)
    delete("/profiles/:username/follow", ProfileController, :unfollow)

    resources "/articles", ArticleController, only: [:index]
    get "/articles/feed", ArticleController, :feed
    get("/articles/:slug", ArticleController, :show)
  end
end
