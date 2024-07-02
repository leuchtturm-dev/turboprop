defmodule Turboprop.Headless.PinInput do
  @moduledoc false
  use Phoenix.Component

  import Turboprop.Headless

  attr :id, :string, default: nil
  attr :as, :any, default: "div"

  attr :type, :string, values: ["alphanumeric", "numeric", "alphabetic"], default: "numeric"
  attr :placeholder, :string, default: nil
  attr :dir, :string, values: ["ltr", "rtl"], default: "ltr"
  attr :otp, :boolean, default: false
  attr :blur_on_complete, :boolean, default: true

  attr :on_change, :string, default: nil
  attr :on_complete, :string, default: nil
  attr :on_invalid, :string, default: nil

  attr :rest, :global
  slot :inner_block

  def accordion(assigns) do
    {type, assigns} = Map.pop(assigns, :type)
    {placeholder, assigns} = Map.pop(assigns, :placeholder)
    {dir, assigns} = Map.pop(assigns, :dir)
    {otp, assigns} = Map.pop(assigns, :otp)
    {blur_on_complete, assigns} = Map.pop(assigns, :blur_on_complete)

    {on_change, assigns} = Map.pop(assigns, :on_change)
    {on_complete, assigns} = Map.pop(assigns, :on_complete)
    {on_invalid, assigns} = Map.pop(assigns, :on_invalid)

    render_as_tag_or_component(assigns, %{
      "id" => assigns.id || id(),
      "phx-hook" => "PinInput",
      "data-type" => type,
      "data-placeholder" => placeholder,
      "data-dir" => dir,
      "data-otp" => otp,
      "data-blur-on-complete" => blur_on_complete,
      "data-on-change" => on_change,
      "data-on-complete" => on_complete,
      "data-on-invalid" => on_invalid
    })
  end

  attr :as, :any, default: "div"
  attr :rest, :global
  slot :inner_block

  def root(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "root"})
  end

  attr :as, :any, default: "input"
  attr :index, :integer, required: true
  attr :rest, :global
  slot :inner_block

  def input(assigns) do
    {index, assigns} = Map.pop(assigns, :index)

    render_as_tag_or_component(assigns, %{"data-part" => "input", "data-index" => index})
  end

  attr :as, :any, default: "span"
  attr :rest, :global
  slot :inner_block

  def label(assigns) do
    render_as_tag_or_component(assigns, %{"data-part" => "label"})
  end
end
