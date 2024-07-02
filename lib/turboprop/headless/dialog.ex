defmodule Turboprop.Headless.Dialog do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :role, :string, values: ["dialog", "alertdialog"], default: "dialog"
  attr :prevent_scroll, :boolean, default: true
  attr :close_on_interact_outside, :boolean, default: true
  attr :close_on_escape, :boolean, default: true
  attr :on_open_change, :string, default: nil, doc: "Event to send when dialog is opened or closed."

  attr :rest, :global
  slot :inner_block

  def dialog(assigns) do
    {role, assigns} = Map.pop(assigns, :role)
    {prevent_scroll, assigns} = Map.pop(assigns, :prevent_scroll)
    {close_on_interact_outside, assigns} = Map.pop(assigns, :close_on_interact_outside)
    {close_on_escape, assigns} = Map.pop(assigns, :close_on_escape)
    {on_open_change, assigns} = Map.pop(assigns, :on_open_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Clipboard",
      "data-role" => role,
      "data-prevent-scroll" => prevent_scroll,
      "data-close-on-interact-outside" => close_on_interact_outside,
      "data-close-on-escape" => close_on_escape,
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

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def backdrop(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "backdrop"})
  end

  attr :as, :any, default: "h2"
  attr :rest, :global
  slot :inner_block

  def title(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "title"})
  end

  attr :as, :any, default: "span"
  attr :rest, :global
  slot :inner_block

  def description(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "description"})
  end

  attr :as, :any, default: "button"
  attr :rest, :global
  slot :inner_block

  def close_trigger(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "close-trigger"})
  end
end
