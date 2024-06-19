defmodule Turboprop.Hooks.Menu do
  @moduledoc """
  A dropdown menu.

  ## Elements

  ### Required elements

  - Trigger: Trigger that opens the menu.
    - Required attributes:
      - `data-part="trigger"`
  - Positioner: Controls the menu's position in the viewport.
    - Required attributes:
      - `data-part="positioner"`
  - Content: Contains the menu content.
    - Needs to be a child of the Positioner.
    - Required attributes:
      - `data-part="content"`
  - Item: Represents an individual action or option within the menu.
    - Needs to be a child of the Content or optionally an Item Group.
    - Required attributes:
      - `data-part="item"`
      - `data-value` - A unique identifier for the item.
    - Styling:
      - Receives a `data-highlighted` attribute when highlighted.

  ### Optional elements

  - Item Group: A group of Items.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="item-group"`
      - `data-value` - A unique identifier for the item group.
      - `name` - A unique name for the item group, if labelled.
  - Item Group Label: A label for an Item Group.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="item-group-label"`
      - `for` - The `name` attribute of the Item Group the label belongs to.
  - Separator: A separator between Items.
    - Needs to be a child of the Content.
    - Required attributes:
      - `data-part="separator"`

  ## Example

  ```heex
  <div id="menu" phx-hook="Menu">
    <button data-part="trigger">Menu</button>
    <div data-part="positioner">
      <div data-part="content">
        <.link navigate="/dashboard" class="data-[highlighted]:bg-gray-100" data-part="item" data-value="dashboard">
          Dashboard
        </.link>
        <hr data-part="separator" />
        <span for="account" data-part="item-group-label">Account</span>
        <div name="account" data-part="item-group" data-value="account" >
          <.link navigate="/signup" data-part="item" data-value="signup">Sign up</.link>
          <.link navigate="/login" data-part="item" data-value="login">Login</.link>
        </div>
      </div>
    </div>
  </div>
  ```
  """
end
