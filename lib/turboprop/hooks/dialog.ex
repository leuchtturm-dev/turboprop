defmodule Turboprop.Hooks.Dialog do
  @moduledoc """
  A dialog component, also known as Modal.

  ## Elements

  ### Required elements

  - Trigger: Trigger that opens the dialog.
    - Required attributes:
      - `data-part="trigger"`
  - Positioner: Controls the dialog's position in the viewport.
    - Required attributes:
      - `data-part="positioner"`
  - Content: Contains the dialog content.
    - Needs to be a child of the Positioner.
    - Required attributes:
      - `data-part="content"`

  ### Optional elements

  - Backdrop: Backdrop to cover the rest of the viewport.
    - Required attributes:
      - `data-part="backdrop"`
  - Title: Title of the dialog.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="title"`
  - Description: Description of the dialog.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="description"`
  - Close trigger: Trigger to close the dialog.
    - Required attributes:
      - `data-part="close-trigger"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-prevent-scroll`: Prevent scrolling of the body behind the dialog. Defaults to `true`.
  - `data-close-on-interact-outside`: Close the dialog when interacting with an element outside of it. Defaults to `true`.
  - `data-close-on-escape`: Close the dialog when the Escape key is pressed. Defaults to `true`.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-open-change`: Emitted when the open state of the dialog changes.

  ## Example

  ```heex
  <div id="dialog" phx-hook="Dialog" data-prevent-scroll data-close-on-interact-outside data-close-on-escape>
    <button data-part="trigger">
      Open dialog
    </button>
    <div data-part="backdrop"></div>
    <div data-part="positioner">
      <div data-part="content">
        <h2 data-part="title">Dialog</h2>
        <span data-part="description">Welcome to Turboprop!</span>
        <button data-part="close-trigger">Close</button>
      </div>
    </div>
  </div>
  ```
  """
end
