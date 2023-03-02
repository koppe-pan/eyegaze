defmodule EyegazeWeb.PageController do
  use EyegazeWeb, :controller

  def index(conn, _params) do
    Eyegaze.Rooms.subscribe()
    user = conn.assigns.current_user

    with {:ok, room} <- Eyegaze.Rooms.create("hoge", owner_user: user.id) do
      conn |> redirect(%{to: "/room", page: room.id})
    end
  end
end
