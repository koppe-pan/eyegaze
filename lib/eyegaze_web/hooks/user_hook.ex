defmodule EyegazeWeb.Hooks.UserHook do
  import Phoenix.LiveView

  @current_user_key "current_user"

  def on_mount(:default, _params, session, socket) do
    {:cont, socket |> assign_new(:current_user, fn -> session[@current_user_key] end)}
  end
end
