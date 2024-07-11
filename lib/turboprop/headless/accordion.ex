defmodule Turboprop.Headless.Accordion do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil

  attr :as, :any,
    default: "div",
    doc: """
    Element or component to render as.

    Can either be a string representing an HTML element, such as `div`, `section` or `button`, or a captured function component, such as
    `&card/1` or `&button/1`.
    """

  attr :disabled, :boolean, default: false, doc: "Disable opening and closing items."
  attr :collapsible, :boolean, default: true, doc: "Allow closing an item after opening it."
  attr :multiple, :boolean, default: false, doc: "Allow multiple items to be open at once."

  attr :on_value_change, :string, default: nil, doc: "Event to send when the value of open items changes."

  attr :rest, :global
  slot :inner_block

  def accordion(assigns) do
    {disabled, assigns} = Map.pop(assigns, :disabled)
    {collapsible, assigns} = Map.pop(assigns, :collapsible)
    {multiple, assigns} = Map.pop(assigns, :multiple)

    {on_value_change, assigns} = Map.pop(assigns, :on_value_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Accordion",
      "data-disabled" => disabled,
      "data-multiple" => multiple,
      "data-collapsible" => collapsible,
      "data-on-value-change" => on_value_change
    })
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def root(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "root"})
  end

  attr :as, :any, default: "div"
  attr :value, :string, required: true
  attr :rest, :global
  slot :inner_block

  def item(assigns) do
    {value, assigns} = Map.pop(assigns, :value)

    render_as_tag_or_component(assigns, %{"data-part" => "item", "data-value" => value})
  end

  attr :as, :any, default: "button"
  attr :rest, :global
  slot :inner_block

  def item_trigger(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "item-trigger"})
  end

  attr :as, :any, default: "span"
  attr :rest, :global
  slot :inner_block

  def item_indicator(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "item-indicator"})
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def item_content(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "item-content"})
  end
end
