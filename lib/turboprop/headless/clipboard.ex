defmodule Turboprop.Headless.Clipboard do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :value, :string, required: true
  attr :timeout, :integer, default: 2000
  attr :on_status_change, :string, default: nil, doc: "Event to send when the copy status changes."

  attr :rest, :global
  slot :inner_block

  def clipboard(assigns) do
    {value, assigns} = Map.pop(assigns, :value)
    {timeout, assigns} = Map.pop(assigns, :timeout)
    {on_status_change, assigns} = Map.pop(assigns, :on_status_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Clipboard",
      "data-value" => value,
      "data-timeout" => timeout,
      "data-on-status-change" => on_status_change
    })
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def root(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "root"})
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def control(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "control"})
  end

  attr :as, :any, default: "input"
  attr :rest, :global

  def input(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "input"})
  end

  attr :as, :any, default: "button"
  attr :rest, :global
  slot :inner_block

  def trigger(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "trigger"})
  end

  attr :as, :any, default: "span"
  attr :rest, :global
  slot :inner_block

  def label(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "label"})
  end
end
