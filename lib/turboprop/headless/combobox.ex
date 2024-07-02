defmodule Turboprop.Headless.Combobox do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :name, :string, default: nil
  attr :input_behavior, :string, values: ["autohighlight", "autocomplete", "none"], default: "none"
  attr :selection_behavior, :string, values: ["clear", "replace", "preserve"], default: "clear"
  attr :disabled, :boolean, default: false
  attr :multiple, :boolean, default: false
  attr :loop_focus, :boolean, default: false
  attr :allow_custom_value, :boolean, default: false
  attr :read_only, :boolean, default: false

  attr :on_open_change, :string, default: nil
  attr :on_input_value_change, :string, default: nil
  attr :on_highlight_change, :string, default: nil
  attr :on_value_change, :string, default: nil

  attr :rest, :global
  slot :inner_block

  def combobox(assigns) do
    {name, assigns} = Map.pop(assigns, :name)
    {input_behavior, assigns} = Map.pop(assigns, :input_behavior)
    {selection_behavior, assigns} = Map.pop(assigns, :selection_behavior)
    {disabled, assigns} = Map.pop(assigns, :disabled)
    {multiple, assigns} = Map.pop(assigns, :multiple)
    {loop_focus, assigns} = Map.pop(assigns, :loop_focus)
    {allow_custom_value, assigns} = Map.pop(assigns, :allow_custom_value)
    {read_only, assigns} = Map.pop(assigns, :read_only)

    {on_open_change, assigns} = Map.pop(assigns, :on_open_change)
    {on_input_value_change, assigns} = Map.pop(assigns, :on_input_value_change)
    {on_highlight_change, assigns} = Map.pop(assigns, :on_highlight_change)
    {on_value_change, assigns} = Map.pop(assigns, :on_value_change)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "Combobox",
      "data-name" => name,
      "data-input-behavior" => input_behavior,
      "data-selection-behavior" => selection_behavior,
      "data-disabled" => disabled,
      "data-multiple" => multiple,
      "data-loop-focus" => loop_focus,
      "data-allow-custom-value" => allow_custom_value,
      "data-read-only" => read_only,
      "data-on-open-change" => on_open_change,
      "data-on-input-value-change" => on_input_value_change,
      "data-on-highlight-change" => on_highlight_change,
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
  attr :rest, :global
  slot :inner_block

  def control(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "control"})
  end

  attr :as, :any, default: "input"
  attr :rest, :global
  slot :inner_block

  def input(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "input"})
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

  attr :as, :any, default: "ul"
  attr :rest, :global
  slot :inner_block

  def content(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "content"})
  end

  attr :id, :string, default: nil
  attr :as, :any, default: "li"
  attr :value, :string, required: true
  attr :label, :string, required: true
  attr :rest, :global
  slot :inner_block

  def item(assigns) do
    {value, assigns} = Map.pop(assigns, :value)
    {label, assigns} = Map.pop(assigns, :label)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "data-part" => "item",
      "data-value" => value,
      "data-label" => label
    })
  end

  attr :as, :any, default: "label"
  attr :rest, :global
  slot :inner_block

  def label(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "label"})
  end
end
