defmodule Turboprop.Hooks.Dialog do
  @moduledoc false
  # TODO: Write documentation and then publish.
  _moduledoc_wip = """
  A dialog component.

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

  def dialog do
    %{"id" => id(), "phx-hook" => "Dialog"}
  end

  def dialog_trigger do
    %{"data-part" => "trigger"}
  end

  def dialog_backdrop do
    %{"data-part" => "backdrop"}
  end

  def dialog_positioner do
    %{"data-part" => "positioner"}
  end

  def dialog_content do
    %{"data-part" => "content"}
  end

  def dialog_title do
    %{"data-part" => "title"}
  end

  def dialog_description do
    %{"data-part" => "description"}
  end

  def dialog_close_trigger do
    %{"data-part" => "close-trigger"}
  end
end
