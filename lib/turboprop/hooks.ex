defmodule Turboprop.Hooks do
  @moduledoc """
  Turboprop Hooks offer an easy way to build accessible components.  

  You can easily add features like keyboard interaction, focus management and ARIA attributes to your component.  
  Turboprop Hooks are built around the state machines of [Zag](https://zagjs.com) and offer the same rules as them. You will find a link to
  each state machine's documentation in the hook's module.

  ## Installation

  ### With mix

  If you use the esbuild setup Phoenix ships with by default, the hooks will automatically be available to your assets after adding
  Turboprop to your `mix.exs`. You then only need to add the hooks to your LiveView configuration.

  ### With npm

  The hooks are also available packaged as an npm package, [`@leuchtturm/turboprop`](https://npmjs.com/package/@leuchtturm/turboprop). Add 
  it to your assets by running `npm i --save-exact @leuchtturm/turboprop` or the equivalent for the package manager you are using.

  ### Loading the hooks
  ```javascript
  import { Hooks } from "@leuchtturm/turboprop";

  let liveSocket = new LiveSocket("/live", Socket, {
    hooks: {
      ...Hooks
    },
  });
  ```

  That's it!

  ## Anatomy

  Each hook comes with a wrapper that adds the `phx-hook` directive and a bunch of `data` attributes that specify which role each element
  has. Revisiting the dropdown menu example from the [Turboprop](`m:Turboprop`) documentation, the expanded elements look like this:

  ```html
  <div id="f4ad5be7thgzohtl" phx-hook="Menu">
    <button
      class="rounded-md bg-blue-500 px-3 py-1.5 text-sm text-white shadow-sm hover:bg-blue-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500"
      data-part="trigger"
    >
      Menu
    </button>
    <div data-part="positioner">
      <div
        class="z-10 w-48 text-sm origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
        data-part="content"
      >
        <Phoenix.Component.link
          id="fb4z3bauifwj5y2p" 
          data-part="item"
          navigate="/link" 
          class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100"
        >
          Link
        </Phoenix.Component.link>
        <a 
          id="eev4amfcwr801wjd" 
          data-part="item"
          href="/anchor" 
          class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100"
        >
          Anchor
        </a>
      </div>
    </div>
  </div>
  ```
  For the `Menu` hook, the required parts are `trigger`, `positioner`, `content`, and `item`. In addition to that, it can also be configured
  with optional parts like `separator` and `group`. Each hook's module will list both required and optional fields and how they relate to
  each other with nesting.  
  Most hooks only need the `data-part` attributes set, but some also have callbacks to the server where an event is required. Check the
  documentation for each hook.

  """

  def id do
    Nanoid.generate(16, "0123456789abcdefghijklmnopqrstuvwxyz")
  end
end
