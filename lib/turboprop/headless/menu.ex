defmodule Turboprop.Headless.Menu do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :rest, :global
  slot :inner_block

  def menu(assigns) do
    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Menu"
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

  attr :as, :any, default: "hr"
  attr :rest, :global
  slot :inner_block

  def separator(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "separator"})
  end

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :rest, :global
  slot :inner_block

  def item_group(assigns) do
    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "data-part" => "item-group"
    })
  end

  attr :as, :any, default: "span"
  attr :rest, :global
  slot :inner_block

  def item_group_label(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "item-group-label"})
  end

  attr :id, :string, default: nil
  attr :as, :any, default: &link/1

  attr :rest, :global
  slot :inner_block

  def item(assigns) do
    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "data-part" => "item"
    })
  end
end
