defmodule Turboprop.Hooks.Clipboard do
  @moduledoc """
  Element allowing users to add a value to their clipboard

  ## Elements

  ### Required elements

  - Root: Wrapper element.
    - Required attributes:
      - `data-part="root"`
  - Control: Wrapper that holds the input and the trigger.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="control"`
  - Input: Input field containing the value.
    - Needs to be a child of the Control.
    - Any `value` attribute set directly on the input will be overwritten when the hook is initialised.
    - Required attributes:
      - `data-part="input"`
  - Trigger: Trigger that copies the value to the user's clipboard.
    - Needs to be a child of the Control.
    - Required attributes:
      - `data-part="trigger"`

  ### Optional elements

  - Label: A label for the element.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="label"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-value`: Value to be copied. Will also set the value of the Input.
  - `data-timeout`: Time in milliseconds after which the state machine will be reset. Has to be an integer.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-status-change`: Emitted when the trigger is activated.
    - Sends an event with the type `%{copied: boolean()}`.

  ## Example

  ```heex
  <div id="clipboard" phx-hook="Clipboard" data-value="https://github.com/leuchtturm-dev/turboprop">
    <label data-part="label">URL</label>
    <div data-part="root">
      <div data-part="control">
        <input data-part="input" />
        <button data-part="trigger">Copy</button>
      </div>
    </div>
  </div>
  ```
  """
end
