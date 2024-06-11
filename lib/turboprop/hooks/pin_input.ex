defmodule Turboprop.Hooks.PinInput do
  @moduledoc """

  Input for PINs and OTPs.

  Consists of multiple inputs, each allowing one character at a time. When the digit or letter is entered, focus transfers to the next 
  input in the sequence, until every input is filled.

  ## Required elements

  - `pin_input`: Wrapper element that initialises the hook and sets configuration.
  - `pin_input_root`: Wrapper around the actual input fields.
  - `pin_input_input`: Input elements, one for each character.

  ## Optional elements

  - `pin_input_label`: Label for the input.

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-type`: The type of the input. Defines which characters are allowed. Has to be one of `alphanumeric`, `numeric` or `alphabetic`.
  - `data-otp`: Add when the input is a One-Time Password to correctly set the `autocomplete` tag.
  - `data-blur-on-complete`: Blur the last input when the user completes the pin input.
  - `data-placeholder`: The placeholder to show in each input field.
  - `data-dir`: Set to `rtl` if the pin should be entered right-to-left.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-change`: Emitted when any of the inputs change.
  - `data-on-complete`: Emitted when all inputs have been filled.
  - `data-on-invalid`: Emitted when the entire input is invalid.

  ### From the server

  The following events can be sent to the component through `push_event/3`.

  - `clear`: Clears the input. Accepts no parameters.

  ## Example

  ```elixir
  def render(assigns) do
    ~H\"\"\"
    <form data-otp data-type="numeric" data-blur-on-complete data-on-complete="submit" {pin_input()}>
      <div {pin_input_root()} class="flex flex-col space-y-2 justify-left">
        <label class="block" {pin_input_label()}>OTP</label>
        <div class="flex space-x-3">
          <input data-index="0" class="size-10 text-center rounded-md" {pin_input_input()} />
          <input data-index="1" class="size-10 text-center rounded-md" {pin_input_input()} />
          <input data-index="2" class="size-10 text-center rounded-md" {pin_input_input()} />
        </div>
      </div>
    </form>
    \"\"\"
  end

  @impl true
  def handle_event("submit", %{"value" => value}, socket) do
    # Do something with value...
    {:noreply, socket}
    
  end
  ```
  """

  import Turboprop.Hooks

  @doc "Wrapper element to initialise the hook."
  def pin_input() do
    %{"id" => id(), "phx-hook" => "PinInput"}
  end

  @doc "Wrapper around the input."
  def pin_input_root() do
    %{"data-part" => "root"}
  end

  @doc "Label for the input."
  def pin_input_label() do
    %{"data-part" => "label"}
  end

  @doc """
  Input element.

  Since the pin input allows one character per input, this element needs to be added multiple times.

  ## Required attributes

  - `data-index`: Increasing index for each input. Needs to be an integer *and* start at `0`.
  """
  def pin_input_input() do
    %{"data-part" => "input"}
  end
end
