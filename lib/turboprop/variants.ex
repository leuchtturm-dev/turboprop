defmodule Turboprop.Variants do
  @moduledoc """
  Turboprop Variants adds a feature-rich variant API for TailwindCSS to Elixir.

  Variants allow you to define all possible styles and options for a component, even one that spans multiple HTML elements, in one place,
  and then apply them based on your assigns.

  ## Example

  ```elixir
  def button() do
    [
      base: "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
      variants: [
        variant: [
          default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
          destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
          outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
          secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
          ghost: "hover:bg-accent hover:text-accent-foreground",
          link: "text-primary underline-offset-4 hover:underline"
        ],
        size: [
          default: "h-9 px-4 py-2",
          sm: "h-8 rounded-md px-3 text-xs",
          lg: "h-10 rounded-md px-8",
          icon: "h-9 w-9"
        ]
      ],
      default_variants: [
        variant: "default",
        size: "default"
      ]
    }
  end
  ```

  ## Features

  Turboprop Variants comes with a ton of features to manage your variants.

  ### Variants

  You can add variants and their options inside the `variants` map. 

  ```elixir
  iex> alert = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-background text-foreground",
  ...>       destructive: "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
  ...>     ]
  ...>   ]
  ...> ]
  iex> variant(alert, variant: "destructive")
  "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive"
  ```

  #### Multiple variants

  Each component can have any number of variants.

  ```elixir
  iex> button = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
  ...>       destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
  ...>       outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
  ...>       secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
  ...>       ghost: "hover:bg-accent hover:text-accent-foreground",
  ...>       link: "text-primary underline-offset-4 hover:underline",
  ...>     ],
  ...>     size: [
  ...>       default: "h-9 px-4 py-2",
  ...>       sm: "h-8 rounded-md px-3 text-xs",
  ...>       lg: "h-10 rounded-md px-8",
  ...>       icon: "h-9 w-9",
  ...>     ],
  ...>   ],
  ...> ]
  iex> variant(button, variant: "destructive", size: "sm")
  "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90 h-8 rounded-md px-3 text-xs"
  ```

  #### Boolean variants

  Some components benefit from having boolean variants, such as `disabled`.  

  Passing only one of `true` and `false` as options is allowed. By default, if the variant is not passed as a keyword and if it exists, the
  `false` value is applied.

  ```elixir
  iex> button = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
  ...>       destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
  ...>     ],
  ...>     disabled: [
  ...>       true: "opacity-50 bg-gray-500 hover:bg-gray-500 pointer-events-none"
  ...>     ],
  ...>   ],
  ...> ]
  iex> variant(button, variant: "default")
  "bg-primary text-primary-foreground shadow hover:bg-primary/90"
  iex> variant(button, variant: "destructive", disabled: true)
  "text-destructive-foreground shadow-sm opacity-50 bg-gray-500 hover:bg-gray-500 pointer-events-none"
  ```

  #### Default variants

  Default variants can easily be set so they do not need to be passed every time.

  ```elixir
  iex> button = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
  ...>       destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
  ...>       outline: "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
  ...>       secondary: "bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",
  ...>       ghost: "hover:bg-accent hover:text-accent-foreground",
  ...>       link: "text-primary underline-offset-4 hover:underline",
  ...>     ],
  ...>     size: [
  ...>       default: "h-9 px-4 py-2",
  ...>       sm: "h-8 rounded-md px-3 text-xs",
  ...>       lg: "h-10 rounded-md px-8",
  ...>       icon: "h-9 w-9",
  ...>     ],
  ...>   ],
  ...>   default_variants: [
  ...>     # Both strings and atoms are fine!
  ...>     variant: "default",
  ...>     size: :default
  ...>   ]
  ...> ]
  iex> variant(button)
  "bg-primary text-primary-foreground shadow hover:bg-primary/90 h-9 px-4 py-2"
  ```

  #### Compound variants

  Turboprop Variants supports variants that depend on other variants.

  ```elixir
  iex> button = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-primary text-primary-foreground shadow hover:bg-primary/90",
  ...>       destructive: "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
  ...>     ],
  ...>     disabled: [
  ...>       true: "opacity-50 bg-gray-500 pointer-events-none"
  ...>     ],
  ...>   ],
  ...>   compound_variants: [
  ...>     [
  ...>       variant: "destructive",
  ...>       disabled: false,
  ...>       class: "focus:ring-1"
  ...>     ]
  ...>   ]
  ...> ]
  iex> variant(button, variant: "destructive", disabled: false)
  "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90 focus:ring-1"
  ```

  The variants also accept arrays, in which case the compound variant will be applied when any of the values match.

  ### Slots

  Slots allow spreading a component's variants over multiple elements.

  When no `slot` option is provided, the `base` one is implied.  
  To be consistent with when not using slots, the `base` slot can also be defined _outside_ the `slots` map.

  ```elixir
  iex> card = [
  ...>   # Can also go here:
  ...>   # base: "md:flex bg-slate-100 rounded-xl p-8 md:p-0 dark:bg-gray-900",
  ...>   slots: [
  ...>     base: "md:flex bg-slate-100 rounded-xl p-8 md:p-0 dark:bg-gray-900",
  ...>     avatar: "w-24 h-24 md:w-48 md:h-auto md:rounded-none rounded-full mx-auto drop-shadow-lg",
  ...>     wrapper: "flex-1 pt-6 md:p-8 text-center md:text-left space-y-4",
  ...>     description: "text-md font-medium",
  ...>   ]
  ...> ]
  iex> variant(card)
  "md:flex bg-slate-100 rounded-xl p-8 md:p-0 dark:bg-gray-900"
  iex> variant(card, slot: :wrapper)
  "flex-1 pt-6 md:p-8 text-center md:text-left space-y-4"
  ```

  #### Slots with variants

  Slots seamlessly work together with variants.

  ```elixir
  iex> card = [
  ...>   slots: [
  ...>     base: "md:flex rounded-xl p-8 md:p-0",
  ...>     avatar: "md:h-auto md:rounded-none rounded-full mx-auto drop-shadow-lg",
  ...>   ],
  ...>   variants: [
  ...>     color: [
  ...>       gray: [
  ...>         base: "bg-slate-100 dark:bg-gray-900"
  ...>       ],
  ...>       red: [
  ...>         base: "bg-red-100 dark:bg-red-900"
  ...>       ]
  ...>     ],
  ...>     size: [
  ...>       sm: [
  ...>         avatar: "w-24 h-24"
  ...>       ],
  ...>       lg: [
  ...>         avatar: "w-48 h-48"
  ...>       ]
  ...>     ]
  ...>   ]
  ...> ]
  iex> variant(card, color: "gray")
  "md:flex rounded-xl p-8 md:p-0 bg-slate-100 dark:bg-gray-900"
  iex> variant(card, color: "red")
  "md:flex rounded-xl p-8 md:p-0 bg-red-100 dark:bg-red-900"
  iex> variant(card, slot: :avatar, size: "lg")
  "md:h-auto md:rounded-none rounded-full mx-auto drop-shadow-lg w-48 h-48"
  ```

  Compound variants can be similarly used with slots.

  #### Compound slots

  Like compound variants, Turboprop Variants also supports adding clases depending on which variants are applied.  
  This is the "Everything everywhere all at once" usage.

  ```elixir
  iex> pagination = [
  ...>   slots: [
  ...>     base: "flex flex-wrap relative gap-1 max-w-fit",
  ...>     item: "data-[active='true']:bg-blue-500 data-[active='true']:text-white",
  ...>   ],
  ...>   variants: [],
  ...>   default_variants: [
  ...>     size: "md"
  ...>   ],
  ...>   compound_slots: [
  ...>     [
  ...>       slots: [:item, :prev, :next],
  ...>       class: [
  ...>         "flex",
  ...>         "flex-wrap",
  ...>         "truncate",
  ...>         "box-border",
  ...>         "outline-none",
  ...>         "items-center",
  ...>         "justify-center",
  ...>         "bg-neutral-100",
  ...>         "hover:bg-neutral-200",
  ...>         "active:bg-neutral-300",
  ...>         "text-neutral-500"
  ...>       ]
  ...>     ],
  ...>     [
  ...>       slots: [:item, :prev, :next],
  ...>       size: "xs",
  ...>       class: "w-7 h-7 text-xs"
  ...>     ],
  ...>     [
  ...>       slots: [:item, :prev, :next],
  ...>       size: "sm",
  ...>       class: "w-8 h-8 text-sm"
  ...>     ],
  ...>     [
  ...>       slots: [:item, :prev, :next],
  ...>       size: "md",
  ...>       class: "w-9 h-9 text-base"
  ...>     ]
  ...>   ]
  ...> ]
  iex> variant(pagination)
  "flex flex-wrap relative gap-1 max-w-fit"
  iex> variant(pagination, slot: :item)
  "data-[active='true']:bg-blue-500 data-[active='true']:text-white flex flex-wrap truncate box-border outline-none items-center justify-center bg-neutral-100 hover:bg-neutral-200 active:bg-neutral-300 text-neutral-500 w-9 h-9 text-base"
  iex> variant(pagination, slot: :prev, size: "xs")
  "flex flex-wrap truncate box-border outline-none items-center justify-center bg-neutral-100 hover:bg-neutral-200 active:bg-neutral-300 text-neutral-500 w-7 h-7 text-xs"
  ```

  ### Overriding class names

  For when that one special element is needed, class overrides can also be passed:


  ```elixir
  iex> alert = [
  ...>   variants: [
  ...>     variant: [
  ...>       default: "bg-background text-foreground",
  ...>       destructive: "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
  ...>     ]
  ...>   ]
  ...> ]
  iex> variant(alert, variant: "default", class: "bg-yellow-500")
  "text-foreground bg-yellow-500"
  ```
  """

  import Turboprop.Merge

  @doc false
  def component(input) do
    input
  end

  @spec variant(map(), keyword()) :: binary()
  @doc """
  Computes a component's classes.

  ## Parameters

  - `component`: A component definition. Refer to the module documentation for its options and structure.
  - `selectors`: A list of selectors.

  ## Selectors

  Selectors are a keyword list containing a few different keys.

  - `slot`: If the passed component has defined slots, they can be selected by passing the `slot` selector. It has to be an atom and
  defaults to `base` if not present.
  - Variants: Pass selectors for each variant. Values can be either atoms or strings.
  """
  def variant(component, selectors \\ [])
  def variant(component, :base), do: component |> add_base(:base) |> merge()

  def variant(component, selectors) when is_list(selectors) do
    variants = Keyword.get(component, :variants, [])
    default_variants = Keyword.get(component, :default_variants, [])
    {boolean_variants, option_variants} = Enum.split_with(variants, fn {_k, v} -> Enum.all?(v, fn {k, _v} -> is_boolean(k) end) end)
    compound_variants = Keyword.get(component, :compound_variants, [])
    compound_slots = Keyword.get(component, :compound_slots, [])
    {override, selectors} = Keyword.pop(selectors, :class, [])
    {slot, selectors} = Keyword.pop(selectors, :slot, :base)

    selectors = selectors |> Enum.reject(fn {_k, v} -> is_nil(v) end) |> then(&Keyword.merge(default_variants, &1))

    component
    |> add_base(slot)
    |> handle_option_variants(option_variants, selectors, slot)
    |> handle_boolean_variants(boolean_variants, selectors, slot)
    |> handle_compound_variants(compound_variants, selectors, slot)
    |> handle_compound_slots(compound_slots, selectors, slot)
    |> handle_override(override)
    |> Enum.reverse()
    |> List.flatten()
    |> merge()
  end

  defp add_base(acc \\ [], component, slot)

  defp add_base(acc, component, :base) do
    base = Keyword.get(component, :base) || fetch_nested(component, [:slots, :base])
    [base | acc]
  end

  defp add_base(acc, component, slot) do
    [fetch_nested(component, [:slots, slot]) | acc]
  end

  defp handle_option_variants(acc, [], _selectors, _slot), do: acc

  defp handle_option_variants(acc, option_variants, selectors, slot) do
    value =
      selectors
      |> transform_selectors()
      |> get_in_option_variant(option_variants, slot)

    [value | acc]
  end

  defp transform_selectors(selectors) when is_atom(selectors), do: List.wrap(selectors)

  defp transform_selectors(selectors) when is_list(selectors) do
    selectors
    |> Keyword.delete(:class)
    |> Enum.map(fn {k, v} ->
      k = safe_to_existing_atom(k)
      v = safe_to_existing_atom(v)
      [k, v]
    end)
  end

  defp safe_to_existing_atom(value) when is_atom(value), do: value

  defp safe_to_existing_atom(value) when is_binary(value) do
    String.to_existing_atom(value)
  rescue
    ArgumentError ->
      nil
  end

  defp get_in_option_variant(selectors, variant, slot)

  defp get_in_option_variant(selectors, variant, slot) when is_list(selectors) do
    selectors
    |> Enum.reduce([], fn selector, acc ->
      value = fetch_nested(variant, selector ++ [slot])
      value = if is_nil(value) and slot == :base, do: fetch_nested(variant, selector), else: value

      [value | acc]
    end)
    |> Enum.sort()
    |> List.flatten()
  end

  defp handle_boolean_variants(acc, [], _selectors, _slot), do: acc

  defp handle_boolean_variants(acc, boolean_variants, selectors, slot) do
    Enum.reduce(boolean_variants, acc, fn {category, values}, acc ->
      option = Keyword.get(selectors, category, false)
      value = get_value_for_boolean(values, option, slot)

      [value | acc]
    end)
  end

  defp get_value_for_boolean(values, option, :base) do
    Keyword.get(values, option) || fetch_nested(values, [option, :base])
  end

  defp get_value_for_boolean(values, option, slot) do
    fetch_nested(values, [option, slot])
  end

  defp handle_compound_variants(acc, [], _selectors, _slot), do: acc

  defp handle_compound_variants(acc, compound_variants, selectors, slot) do
    Enum.reduce(compound_variants, acc, fn compound_variant, acc ->
      {class, compound_variant} = Keyword.pop(compound_variant, :class)

      apply? =
        Enum.all?(compound_variant, fn
          {k, v} when is_list(v) -> Enum.member?(v, Keyword.get(selectors, k))
          {k, v} -> Keyword.get(selectors, k) == v
        end)

      if apply? do
        value = fetch_nested(class, [slot])
        value = if is_nil(value) and slot == :base, do: class, else: value

        [value | acc]
      else
        acc
      end
    end)
  end

  defp handle_compound_slots(acc, compound_slots, selectors, slot) do
    Enum.reduce(compound_slots, acc, fn compound_slot, acc ->
      {slots, compound_slot} = Keyword.pop(compound_slot, :slots)
      {class, compound_slot} = Keyword.pop(compound_slot, :class)

      apply? =
        slot in slots and
          Enum.all?(compound_slot, fn
            {k, v} when is_list(v) -> Enum.member?(v, Keyword.get(selectors, k))
            {k, v} -> Keyword.get(selectors, k) == v
          end)

      if apply? do
        [class | acc]
      else
        acc
      end
    end)
  end

  defp handle_override(acc, override) do
    [override | acc]
  end

  defp fetch_nested(current_value, []) when is_binary(current_value) or is_list(current_value), do: current_value
  defp fetch_nested(_current_value, []), do: nil

  defp fetch_nested(current_value, [key | rest]) do
    if is_list(current_value) and Keyword.has_key?(current_value, key) do
      fetch_nested(current_value[key], rest)
    end
  end
end
