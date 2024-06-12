defmodule Turboprop.Hooks.Dialog do
  @moduledoc """
  A dialog component, also known as Modal.

  ## Required elements

  - `dialog`: Wrapper element that initialises the hook and sets configuration.
  - `dialog_trigger`: Trigger that opens the dialog.
  - `dialog_positioner`: Controls the menu's position in the viewport.
  - `dialog_content`: Contains the dialog content.

  ## Optional elements

  - `dialog_backdrop`: Backdrop to cover the rest of the viewport.
  - `dialog_title`: Title of the dialog.
  - `dialog_description`: Description of the dialog.
  - `dialog_close_trigger`: Trigger to close the dialog.

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
  <div {dialog()}>
    <button
      class="rounded-md bg-blue-500 px-3 py-1.5 text-sm text-white shadow-sm hover:bg-blue-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500"
      {dialog_trigger()}
    >
      Open dialog
    </button>
    <div class="absolute inset-0 w-full h-full bg-gray-200" {dialog_backdrop()}></div>
    <div class="fixed inset-0 z-10 w-screen overflow-y-auto flex min-h-full items-center justify-center p-4" {dialog_positioner()}>
      <div class="w-full max-w-md rounded-xl bg-white p-6 outline-0" {dialog_content()}>
        <h2 class="text-base font-medium" {dialog_title()}>Dialog</h2>
        <span class="mt-2 text-sm" {dialog_description()}>Welcome to Guillotine!</span>
        <div class="mt-4">
          <button
            class="rounded-md bg-blue-500 px-3 py-1.5 text-sm text-white shadow-sm hover:bg-blue-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500"
            {dialog_close_trigger()}
          >
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
  ```
  """

  import Turboprop.Hooks

  @doc "Wrapper element to initialise the hook."
  def dialog do
    %{
      "id" => id(),
      "phx-hook" => "Dialog",
      "data-prevent-scoll" => "",
      "data-close-on-interact-outside" => "",
      "data-close-on-escape" => ""
    }
  end

  @doc """
  Trigger to open the dialog.

  Needs to be positioned as child of `dialog/0`.
  """
  def dialog_trigger do
    %{"data-part" => "trigger"}
  end

  @doc """
  Backdrop element.

  Needs to be positioned as child of `dialog/0`.
  """
  def dialog_backdrop do
    %{"data-part" => "backdrop"}
  end

  @doc """
  Element to position a dialog in the viewport.

  Needs to be positioned as child of `dialog/0`.
  """
  def dialog_positioner do
    %{"data-part" => "positioner"}
  end

  @doc """
  Content of the dialog.

  Needs to be positioned as child of `dialog_positioner/0`.
  """
  def dialog_content do
    %{"data-part" => "content"}
  end

  @doc """
  Title of the dialog.

  Needs to be positioned as child of `dialog_content/0`.
  """
  def dialog_title do
    %{"data-part" => "title"}
  end

  @doc """
  Description of the dialog.

  Needs to be positioned as child of `dialog_content/0`.
  """
  def dialog_description do
    %{"data-part" => "description"}
  end

  @doc """
  Trigger to close the dialog.

  Needs to be positioned as child of `dialog/0`.
  """
  def dialog_close_trigger do
    %{"data-part" => "close-trigger"}
  end
end
