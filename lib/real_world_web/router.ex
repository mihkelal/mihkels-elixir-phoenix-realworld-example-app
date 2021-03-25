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

    resources("/users", UserController,  singleton: true, only: [:create]) do
      post("/login", SessionController, :create)
    end
    resources("/user", UserController, singleton: true, only: [:show, :update])

    resources("/profiles", ProfileController, param: "username", only: [:show])
    post("/profiles/:username/follow", ProfileController, :follow)
    delete("/profiles/:username/follow", ProfileController, :unfollow)

    get("/articles/feed", ArticleController, :feed)
    resources("/articles", ArticleController, param: "slug", except: [:new, :edit]) do
      resources("/comments", CommentController, only: [:index, :create])
    end
  end
end
