defmodule Turboprop.Hooks.Collapsible do
  @moduledoc """
  Element that can be opened and closed.

  ## Elements

  ### Required elements

  - Root: Wrapper element.
    - Required attributes:
      - `data-part="root"`
  - Trigger: Trigger that opens and closes the collapsible.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="trigger"`
  - Content: Wrapper for the content inside the collapsible.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="content"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-disabled` - *boolean*: Whether the collapsible is disabled and can be interacted with.
  - `data-dir`: Set to `rtl` if the collapsible should be rendered in right-to-left direction.
    - One of `ltr` or `rtl`.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-open-change`: Emitted when the open state of the collapsible changes.
    - Sends an event with the type `%{open: boolean()}`

  ## Example

  ```heex
  <div id="collapsible" phx-hook="Collapsible">
    <div data-part="root">
      <button data-part="trigger">Open</button>
      <div data-part="content">
        What, another copy text to write?
      </div>
    </div>
  </div>
  ```
  """
end
