defmodule Turboprop.Headless.Collapsible do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :disabled, :boolean, default: false, doc: "Disable the collapsible."
  attr :dir, :string, values: ["ltr", "rtl"], default: "ltr"
  attr :on_open_change, :string, default: nil, doc: "Event to send when collapsible is opened or closed."

  attr :rest, :global
  slot :inner_block

  def collapsible(assigns) do
    {disabled, assigns} = Map.pop(assigns, :disabled)
    {dir, assigns} = Map.pop(assigns, :dir)
    {on_open_change, assigns} = Map.pop(assigns, :on_open_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Clipboard",
      "data-disabled" => disabled,
      "data-dir" => dir,
      "data-on-open-change" => on_open_change
    })
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def root(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "root"})
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

  def content(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "content"})
  end
end
