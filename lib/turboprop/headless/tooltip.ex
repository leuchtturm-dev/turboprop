defmodule Turboprop.Headless.Tooltip do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :open_delay, :integer, default: 500
  attr :close_delay, :integer, default: 250

  attr :close_on_escape, :boolean, default: true
  attr :close_on_scroll, :boolean, default: true
  attr :close_on_pointer_down, :boolean, default: true

  attr :on_open_change, :string, default: nil

  attr :rest, :global
  slot :inner_block

  def tooltip(assigns) do
    {open_delay, assigns} = Map.pop(assigns, :open_delay)
    {close_delay, assigns} = Map.pop(assigns, :close_delay)

    {close_on_escape, assigns} = Map.pop(assigns, :close_on_escape)
    {close_on_scroll, assigns} = Map.pop(assigns, :close_on_scroll)
    {close_on_pointer_down, assigns} = Map.pop(assigns, :close_on_pointer_down)

    {on_open_change, assigns} = Map.pop(assigns, :on_open_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Tooltip",
      "data-open-delay" => open_delay,
      "data-close-delay" => close_delay,
      "data-close-on-escape" => close_on_escape,
      "data-close-on-scroll" => close_on_scroll,
      "data-close-on-pointer-down" => close_on_pointer_down,
      "data-on-open-change" => on_open_change
    })
  end

  attr :as, :any, default: "button"
  attr :rest, :global
  slot :inner_block

  def trigger(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "trigger"})
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def positioner(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "positioner"})
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def content(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "content"})
  end
end
