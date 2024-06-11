defmodule Turboprop.Hooks.Menu do
  @moduledoc """
  Provides a robust, accessible dropdown and context menu system. This module serves as a wrapper around
  [Zag's Menu state machine](https://github.com/chakra-ui/zag/tree/main/packages/machines/menu), designed for displaying a list of actions 
  or options to the user within a web application. 

  ### Required Components:
  - `menu`: The main container for the menu.
  - `menu_trigger`: Activates the dropdown or context menu.
  - `menu_positioner`: Controls the menu's position in the viewport.
  - `menu_content`: Contains the clickable menu items.
  - `menu_item`: Represents an individual action or option within the menu.

  ### Optional Components:
  - `menu_item_group`: Groups related items within the menu.
  - `menu_item_group_label`: Provides a label for item groups, enhancing accessibility.
  - `menu_separator`: Visually separates items or groups within the menu.

  ## Example

  ```heex
  <div {menu()}>
    <button
      class="rounded-md bg-blue-500 px-3 py-1.5 text-sm text-white shadow-sm hover:bg-blue-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500"
      {menu_trigger()}
    >
      Menu
    </button>
    <div {menu_positioner()}>
      <div
        class="z-10 w-48 text-sm origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
        {menu_content()}
      >
        <.link navigate="/dashboard" class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100" {menu_item()}>
          Dashboard
        </.link>
        <hr {menu_separator()} />
        <span data-for="account" class="block px-4 py-2 text-gray-500" {menu_item_group_label()}>Account</span>
        <div name="account" {menu_item_group()}>
          <.link navigate="/signup" class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100" {menu_item()}>
            Sign up
          </.link>
          <.link navigate="/login" class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100" {menu_item()}>
            Login
          </.link>
        </div>
      </div>
    </div>
  </div>
  ```
  """

  import Turboprop.Hooks

  @doc """
  Wrapper element for menus.

  ## Required attributes

  - `id` - Will be auto-generated if not set.
  """
  def menu do
    %{"id" => id(), "phx-hook" => "Menu"}
  end

  @doc """
  Button to open a menu.

  Needs to be positioned as direct child of `menu/0`.
  """
  def menu_trigger do
    %{"data-part" => "trigger"}
  end

  @doc """
  Element to position a menu in the viewport.

  Needs to be positioned as direct child of `menu/0`.
  """
  def menu_positioner do
    %{"data-part" => "positioner"}
  end

  @doc """
  Wrapper around menu items.

  Needs to be positioned as direct child of `menu_positioner/0`.
  """
  def menu_content do
    %{"data-part" => "content"}
  end

  @doc """
  Element to separate menu items.

  Needs to be positioned as direct child of either `menu_content/0` or `menu_item_group/0`.
  """
  def menu_separator do
    %{"data-part" => "separator"}
  end

  @doc """
  Element to group multiple menu items together.

  ## Required attributes

  - `id` - Will be auto-generated if not set.
  - `name` - If adding a label through `menu_item_group_label/0`, the group needs to have a name set.
  """
  def menu_item_group do
    %{"data-id" => id(), "data-part" => "item-group"}
  end

  @doc """
  Label for a menu group.

  ## Required attributes

  - `data-for` - The `menu_item_group/0`'s `name`.
  """
  def menu_item_group_label do
    %{"data-part" => "item-group-label"}
  end

  @doc """
  Menu item.

  ## Required attributes

  - `id` - Will be auto-generated if not set.

  ## Styling

  When a menu item is highlighted, it will receive a `data-highlighted` attribute which can be used to style the item. If using Tailwind,
  this can be achieved by adding `data-[highlighted]:bg-gray-100` to the class list.
  """
  def menu_item do
    %{"data-id" => id(), "data-part" => "item"}
  end
end
