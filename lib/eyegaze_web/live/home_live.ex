defmodule EyegazeWeb.HomeLive do
  use EyegazeWeb, :live_view

  alias Eyegaze.Rooms

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Eyegaze.Rooms.subscribe()
    end
    Eyegaze.Rooms.subscribe()

    rooms = Rooms.list()
    Process.send_after(self(), :next, 1000)

    {:ok, assign(socket, page_title: "ルーム一覧", rooms: rooms, create_room_name: "")}
  end

  def render(assigns) do
    ~H"""
    """
  end


  @impl Phoenix.LiveView
  def handle_info(:next, socket) do
    user = socket.assigns.current_user

    with {:ok, room} <- Eyegaze.Rooms.create("hoge", owner_user_id: user.id) do
      {:noreply, push_redirect(socket, to: Routes.room_path(socket, :page, room.id))}
    end
  end
end
