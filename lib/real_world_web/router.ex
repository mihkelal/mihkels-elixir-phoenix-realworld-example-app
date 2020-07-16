defmodule RealWorldWeb.Router do
  use RealWorldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealWorldWeb do
    pipe_through :api
  end
end
