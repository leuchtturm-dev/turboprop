defmodule Turboprop.Hooks.PinInput do
  @moduledoc """
  Input for PINs and OTPs.

  Consists of multiple inputs, each allowing one character at a time. When the digit or letter is entered, focus transfers to the next 
  input in the sequence, until every input is filled.

  ## Elements

  ### Required elements

  - Root: Wrapper element.
    - Required attributes:
      - `data-part="root"`
  - Input: An input for a single character.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="input"`
      - `data-index` - An integer describing the index of the current input. Needs to start at `0` for the first input. 

  ### Optional elements

  - Label: A label for the pin input.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="label"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-type`: The type of the input. Defines which characters are allowed.
    - One of `alphanumeric`, `numeric` or `alphabetic`.
  - `data-otp` - *boolean*: Add when the input is a One-Time Password to correctly set the `autocomplete` tag.
  - `data-blur-on-complete` - *boolean*: Blur the last input when the user completes the pin input.
  - `data-placeholder`: The placeholder to show in each input field.
  - `data-dir`: Set to `rtl` if the pin should be entered right-to-left.
    - One of `ltr` or `rtl`.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-change`: Emitted when any of the inputs change.
    - Sends an event with the type `%{value: list(binary()), valueAsString: binary()}`
  - `data-on-complete`: Emitted when all inputs have been filled.
    - Sends an event with the type `%{value: list(binary()), valueAsString: binary()}`
  - `data-on-invalid`: Emitted when the entire input is invalid.
    - Sends an event with the type `%{value: binary(), index: integer()}`

  ### From the server

  The following events can be sent to the component through `push_event/3`.

  - `clear`: Clears the input. Accepts no parameters.

  ## Example

  ```elixir
  def render(assigns) do
    ~H\"\"\"
    <form id="pin-input" phx-hook="PinInput" data-otp data-type="numeric" data-blur-on-complete data-on-complete="submit">
      <div data-part="root">
        <label data-part="label">OTP</label>
        <div>
          <input data-part="input" data-index="0" />
          <input data-part="input" data-index="1" />
          <input data-part="input" data-index="2" />
          <input data-part="input" data-index="3" />
          <input data-part="input" data-index="4" />
          <input data-part="input" data-index="5" />
        </div>
      </div>
    </form>
    \"\"\"
  end

  @impl true
  def handle_event("submit", %{"valueAsString" => value}, socket) do
    # Do something with value...
    {:noreply, socket}
    
  end
  ```
  """
end
