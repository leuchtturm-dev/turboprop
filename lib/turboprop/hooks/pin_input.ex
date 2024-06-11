defmodule Turboprop.Hooks.PinInput do
  @moduledoc false

  import Turboprop.Hooks

  def pin_input() do
    %{"id" => id(), "phx-hook" => "PinInput"}
  end

  def pin_input_root() do
    %{"id" => id(), "data-part" => "root"}
  end

  def pin_input_input() do
    %{"data-part" => "input"}
  end
end
