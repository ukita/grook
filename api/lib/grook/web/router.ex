defmodule Grook.Web.Router do
  use Grook.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Grook.Web.Plug.Locale
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :protected do
    plug Guardian.Plug.EnsureAuthenticated, handler: Grook.Guardian.ErrorHandler
    plug Guardian.Plug.EnsureResource  
  end

  scope "/api", Grook.Web do
    pipe_through :api

    post "/tokens", TokenController, :create
    post "/users", UserController, :create
  end

  scope "/api", Grook.Web do
    pipe_through [:api, :protected]

    resources "/users", UserController, only: [:show]

    get "/me", AccountController, :show
    patch "/me", AccountController, :update
    put "/me", AccountController, :update
    delete "/me", AccountController, :delete

    post "/posts/attachments", PostAttachmentController, :create

    resources "/rooms", RoomController do
      resources "/posts", PostController, only: [:index, :create] do
        resources "/reactions", ReactionController, only: [:create, :delete]
      end
      
      resources "/members", MemberController, only: [:index]
      post "/join", MemberController, :create
      delete "/leave", MemberController, :delete
    end
  end
end
