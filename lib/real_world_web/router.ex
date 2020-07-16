defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RealWorldWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    get("/user", UserController, :show)
    put("/user", UserController, :update)
  end
end
