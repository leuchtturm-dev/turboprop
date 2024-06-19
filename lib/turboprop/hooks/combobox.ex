defmodule Turboprop.Hooks.Combobox do
  @moduledoc """
  A combobox hook that provides an interactive dropdown list for selecting values.

  Allows users to either select an item from a predefined list or enter a custom value depending on configuration. 

  ## Elements

  ### Required elements

  - Root: Wrapper element.
    - Required attributes:
      - `data-part="root"`
  - Control: Wrapper that holds the input and the trigger for the dropdown.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="control"`
  - Input: Text input field where users search in the list.
    - Needs to be a child of the Control.
    - Required attributes:
      - `data-part="input"`
  - Trigger: Trigger that opens the menu.
    - Needs to be a child of the Control.
    - Required attributes:
      - `data-part="trigger"`
  - Positioner: A container for the dropdown content.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="positioner"`
  - Content: The actual list of items.
    - Needs to be a child of the Positioner.
    - Required attributes:
      - `data-part="content"`
  - Item: Each selectable item in the dropdown list.
    - Needs to be a child of the Positioner.
    - Required attributes:
      - `data-part="item"`
      - `data-value` - Value of the item.
      - `data-label` - Human-readable label of the item.
    - Styling:
      - Receives a `data-highlighted` attribute when highlighted.
      - Receives a `data-state="checked"` attribute when selected.

  ### Optional elements

  - Label: A label for the combobox.
    - Needs to be a child of the Root.
    - Required attributes:
      - `data-part="label"`

  ## Options

  Options are set on the outer wrapper element through data attributes.

  - `data-name`: The name of the `input` field. Required for use in forms.
  - `data-input-behavior`: Determines how the input behaves in terms of autocomplete and highlighting.
    - One of `autohighlight`, `autocomplete` or `none`.
  - `data-selection-behavior`: Determines how the selection behaves upon item selection.
    - One of `clear`, `replace` or `preserve`.
  - `data-multiple` - *boolean*: Whether multiple items can be selected.
  - `data-loop-focus` - *boolean*: Whether focus should loop back to the top when reaching the end or vice versa.
  - `data-allow-custom-value` - *boolean*: Allows entering a value that is not in the predefined list.
  - `data-disabled` - *boolean*: Disables the combobox interaction.
  - `data-read-only` - *boolean*: Makes the combobox read-only.

  ## Events

  ### From the client

  - `data-on-open-change`: Emitted when the dropdown opens or closes.
    - Sends an event with the type `%{open: boolean()}`.
  - `data-on-input-value-change`: Emitted when the input value changes.
    - Sends an event with the type `%{inputValue: binary()}`.
  - `data-on-highlight-change`: Emitted when the highlighted item changes.
    - Sends an event with the type `%{highlightedValue: binary(), highlightedItem: %{value: binary(), label: binary()}}`.
  - `data-on-value-change`: Emitted when the selected value changes.
    - Sends an event with the type `%{value: list(binary()), items: list(%{value: binary(), label: binary()})}`.

  ## Example

  ```elixir
  @items [
    %{label: "United States", id: "US"},
    %{label: "Germany", id: "DE"},
    %{label: "India", id: "IN"},
    %{label: "Brazil", id: "BR"},
    %{label: "Canada", id: "CA"},
    %{label: "France", id: "FR"},
    %{label: "Japan", id: "JP"},
    %{label: "South Korea", id: "KR"},
    %{label: "Australia", id: "AU"},
    %{label: "Italy", id: "IT"},
    %{label: "Spain", id: "ES"},
    %{label: "Nigeria", id: "NG"},
    %{label: "Russia", id: "RU"},
    %{label: "China", id: "CN"},
    %{label: "United Kingdom", id: "GB"},
    %{label: "Mexico", id: "MX"},
    %{label: "Indonesia", id: "ID"},
    %{label: "Turkey", id: "TR"},
    %{label: "South Africa", id: "ZA"},
    %{label: "Sweden", id: "SE"},
    %{label: "Argentina", id: "AR"},
    %{label: "Belgium", id: "BE"},
    %{label: "Thailand", id: "TH"},
    %{label: "New Zealand", id: "NZ"},
    %{label: "Norway", id: "NO"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :items, @items)}
  end

  def handle_event("search", %{"inputValue" => query}, socket) do
    items = if query == "", do: @items, else: Enum.filter(@items, &String.starts_with?(String.downcase(&1.label), String.downcase(query)))
    {:noreply, assign(socket, :items, items)}
  end

  def handle_event("save", %{"value" => value}, socket) do
    # Do something with value...

    {:noreply, socket}
  end

  def render(assigns) do
    ~H\"\"\"
    <div id="combobox" phx-hook="Combobox" data-on-input-value-change="search" data-on-value-change="save">
      <label data-part="label">Select country</label>
      <div data-part="root">
        <div data-part="control">
          <input data-part="input" />
          <button data-part="trigger">Open</button>
        </div>
      </div>
      <div data-part="positioner">
        <ul data-part="content">
          <li :for={item <- @items} id={item.id} data-part="item" data-value={item.id} data-label={item.label}>
            <%= item.label %>
          </li>
        </ul>
      </div>
    </div>
    \"\"\"
  end
  ```
  """
end
