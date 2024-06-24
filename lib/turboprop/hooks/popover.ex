defmodule Turboprop.Hooks.Popover do
  @moduledoc """
  A popover component.

  ## Elements

  ### Required elements

  - Trigger: Trigger that opens the popover.
    - Required attributes:
      - `data-part="trigger"`
  - Positioner: Controls the popover's position in the viewport.
    - Required attributes:
      - `data-part="positioner"`
  - Content: Contains the popover content.
    - Needs to be a child of the Positioner.
    - Required attributes:
      - `data-part="content"`

  ### Optional elements

  - Title: Title of the popover.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="title"`
  - Description: Description of the popover.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="description"`
  - Close trigger: Trigger to close the popover.
    - Required attributes:
      - `data-part="close-trigger"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-auto-focus` - *boolean*: Automatically set focus to the first focusable element in the popover.
  - `data-modal` - *boolean*: Treat the popover as a modal and trap focus.
  - `data-close-on-interact-outside` - *boolean*: Close the popover when interacting with an element outside of it.
  - `data-close-on-escape` - *boolean*: Close the popover when the Escape key is pressed.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-open-change`: Emitted when the open state of the popover changes.
    - Sends an event with the type `%{open: boolean()}`

  ## Example

  ```heex
  <div id="popover" phx-hook="Popover" data-auto-focus data-close-on-interact-outside data-close-on-escape>
    <button data-part="trigger">
      Open popover
    </button>
    <div data-part="positioner">
      <div data-part="content">
        <h2 data-part="title">Popover</h2>
        <span data-part="description">Welcome to Turboprop!</span>
        <button data-part="close-trigger">Close</button>
      </div>
    </div>
  </div>
  ```
  """
end
