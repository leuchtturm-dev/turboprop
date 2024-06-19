defmodule Turboprop.Hooks.Accordion do
  @moduledoc """
  An accordion.

  ## Elements

  ### Required elements

  - Root: Wrapper element.
    - Required attributes:
      - `data-part="root"`
  - Item: Represents a single accordion item.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="item"`
      - `data-value` - A unique identifier for the item.
  - Item Trigger: Trigger that opens its item.
    - Needs to be a child of an Item.
    - Required attributes:
      - `data-part="item-trigger"`
  - Item Content: Content of an item.
    - Needs to be a child of an Item.
    - Required attributes:
      - `data-part="item-content"`

  ### Optional elements

  - Item Indicator: An indicator showing whether an item is opened.
    - Needs to be a child of an Item.
    - Required attributes:
      - `data-part="item-indicator"`

  ## Options

  Options are set on the outer wrapper element through data attributes.  
  For boolean attributes, adding the attribute with either an empty value or `"true"` is considered truthy, every other value falsy.

  - `data-disabled` - *boolean*: Whether the accordion is disabled and can be interacted with.
  - `data-multiple` - *boolean*: Whether multiple items can be opened at the same time.
  - `data-collapsible` - *boolean*: Whether an item can be closed by the user by clicking on it again. Implicitly set when `data-multiple`
  is set.

  ## Events

  ### From the client

  If set, the client will push the following events to the server:

  - `data-on-value-change`: Emitted when items are opened or closed.
    - Sends an event with the type `%{value: list(binary())}` where the list contains the `data-value` of each opened item.

  ## Example

  ```heex
  <div id="accordion" phx-hook="Accordion" data-collapsible>
    <div data-part="root">
      <div data-part="item" data-value="one">
        <button data-part="item-trigger">This is one element.</button>
        <div data-part="item-content">It's really difficult to come up with texts for these, to be honest.</div>
      </div>
      <div data-part="item" data-value="two">
        <button data-part="item-trigger">This is another element.</button>
        <div data-part="item-content">Really, a second one isn't easier.</div>
      </div>
    </div>
  </div>
  ```
  """
end
