defmodule Turboprop.Hooks.Menu do
  @moduledoc """
  An accessible dropdown and context menu that is used to display a list of actions or options that a user can choose.

  Wrapper around [Zag's Menu state machine](https://github.com/chakra-ui/zag/tree/main/packages/machines/menu).

  ## Required parts

  - `menu` - Root element owning the hook.
  - `menu_trigger` - Element opening the hook.
  - `menu_positioner` - Element positioning the element in the viewport.
  - `menu_content` - Wrapper element around the items.
  - `menu_item` - Selectable item in the menu.

  ## Optional parts

  - `menu_item_group` - Wrapper around a group of items.
  - `menu_item_group_label` - Label for a group of items.
  - `menu_separator` - Separator between two groups of items.

  ## Item Groups

  When grouping items, groups can be labeled. To give the group element label, it requires a `name` attribute with the corresponding label
  having a `data-for` attribute set. The example below shows this.

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

  def menu do
    %{"id" => id(), "phx-hook" => "Menu"}
  end

  def menu_trigger do
    %{"data-part" => "trigger"}
  end

  def menu_positioner do
    %{"data-part" => "positioner"}
  end

  def menu_content do
    %{"data-part" => "content"}
  end

  def menu_separator do
    %{"data-part" => "separator"}
  end

  def menu_item_group_label do
    %{"data-part" => "item-group-label"}
  end

  def menu_item_group do
    %{"data-id" => id(), "data-part" => "item-group"}
  end

  def menu_item do
    %{"data-id" => id(), "data-part" => "item"}
  end
end
