defmodule EyegazeWeb.LiveHelpers do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign(:attrs, assigns_to_attributes(assigns, [:icon, :class]))

    ~H"""
    <span class={"material-icons align-middle #{@class}"} {@attrs}>
      <%= @icon %>
    </span>
    """
  end

  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:show, fn -> false end)
      |> assign_new(:patch, fn -> nil end)
      |> assign_new(:navigate, fn -> nil end)
      |> assign_new(:class, fn -> "" end)
      |> assign(:attrs, assigns_to_attributes(assigns, [:id, :show, :patch, :navigate, :class]))

    ~H"""
    <div
      id={@id}
      class={"fixed z-[10000] inset-0 #{if @show, do: "fade-in", else: "hidden"}"}
      phx-remove={JS.transition("fade-out")}
      {@attrs}
    >
      <div class="modal modal-open">
        <div
          class={"modal-box #{@class}"}
          phx-window-keydown={hide_modal(@id)}
          phx-click-away={hide_modal(@id)}
          phx-key="escape"
        >
          <%= if @patch do %>
            <%= live_patch("", to: @patch, class: "hidden", id: "#{@id}-return") %>
          <% end %>
          <%= if @navigate do %>
            <%= live_redirect("", to: @navigate, class: "hidden", id: "#{@id}-return") %>
          <% end %>
          <button
            type="button"
            class="absolute top-6 right-6 text-gray-400 flex space-x-1 items-center"
            aria_label="close modal"
            phx-click={hide_modal(@id)}
          >
            <span class="text-sm">(esc)</span>
            <.icon icon="close" class="text-2xl" />
          </button>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  def show_modal(js \\ %JS{}, id) do
    js
    |> JS.show(
      to: "##{id}",
      transition: {"ease-out duration-200", "opacity-0", "opacity-100"}
    )
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.dispatch("click", to: "##{id}-return")
  end
end
