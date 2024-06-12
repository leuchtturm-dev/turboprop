# Turboprop

[![Hex.pm](https://img.shields.io/hexpm/v/turboprop)](https://hex.pm/packages/turboprop)
[![npm](https://img.shields.io/npm/v/@leuchtturm/turboprop)](https://npmjs.com/package/@leuchtturm/turboprop)
[![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/turboprop/)

<p align="center">
  <img src="https://github.com/leuchtturm-dev/turboprop/raw/main/assets/turboprop.png" width="300" />
</p>

A toolkit to build beautiful, accessible components for Phoenix using Tailwind and Zag.

## State

This project is still at version `0.1` and should not be used in production as here still is a lot of documentation going on.

- The Turboprops Hook API will most definitely change, and the amount of hooks currently available is very limited. In addition to that,
they might not be fully documented or lack options.
- The Turboprop Merge API is considered stable, but it lacks the ability to configure it with custom Tailwind themes and the documentation
is considered work in progress.

## Contributing

While this project is at `0.1` and still a highly experimental playground, we are not looking for contributions. Once the API is a little
more stable and the project takes shape, this will of course change!

<!-- MDOC !-->

## Tools

Turboprop consists of multiple tools, each with their own purpose in building your component library.

### Turboprop Hooks

Turboprop Hooks allow adding a ton of accessibility features to your components by simply adding a hook and a few data attributes to them.  
This includes:

- Keyboard interactions
- Focus management
- ARIA attributes

You can either install and use them through the hex.pm dependency and some helpers we offer to add the relevant attributes to a component,
or install them directly through npm and adding the attributes yourself.  

As an example, this renders a fully accessible dropdown menu:

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
      <Phoenix.Component.link navigate="/link" class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100" {menu_item()}>
        Link
      </Phoenix.Component.link>
      <a href="/anchor" id="test" class="block px-4 py-2 outline-0 data-[highlighted]:bg-gray-100" {menu_item()}>Anchor</a>
    </div>
  </div>
</div>
```

### Turboprop Merge

Turboprop Merge allows you to easily merge a list of Tailwind Classes to avoid style conflicts.

Imagine this component:

```elixir
attr :class, :string, doc: "Class override"
def button(assigns) do
  ~H"""
  <button class={["bg-black px-3 py-1.5 text-sm", @class]}>Click me!</button>
  """
end
```

And imagine wanting to make the text a little bigger as a one-off. You've already added a `@class` attribute, but rendering the component
with `class="text-lg"` will lead to an HTML output of `"bg-black px-3 py-1.5 text-sm text-lg"`, with two competing font size classes.

Now, replace the `class` attribute with `class={merge(["bg-black px-3 py-1.5 text-sm", @class])}` and you will magically get
`"bg-black px-3 py-1.5 text-lg"`.

<!-- MDOC !-->

## Acknowledgements

### Turboprop Merge

This type of library exists in the JavaScript world already, in multiple flavors. Turboprop Merge was heavily inspired especially by
[tailwind-merge](https://www.npmjs.com/package/tailwind-merge), so much so that we copied their tests as a starting point. This sped up
development time immensely and we are insanely grateful for being able to steal their test cases.
