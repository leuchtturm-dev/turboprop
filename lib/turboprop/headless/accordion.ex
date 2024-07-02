defmodule Turboprop.Headless.Accordion do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :disabled, :boolean, default: false, doc: "Disable opening and closing items."
  attr :collapsible, :boolean, default: true, doc: "Allow closing an item after opening it."
  attr :multiple, :boolean, default: false, doc: "Allow multiple items to be open at once."

  attr :rest, :global
  slot :inner_block

  def accordion(assigns) do
    {disabled, assigns} = Map.pop(assigns, :disabled)
    {collapsible, assigns} = Map.pop(assigns, :collapsible)
    {multiple, assigns} = Map.pop(assigns, :multiple)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Accordion",
      "data-disabled" => disabled,
      "data-multiple" => multiple,
      "data-collapsible" => collapsible
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
    render_as_tag_or_component(assigns, %{"data-part" => "item", "data-value" => assigns.value})
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
