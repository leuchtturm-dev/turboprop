defmodule Turboprop.Variants do
  import Turboprop.Merge

  def component(input) do
    input
  end

  def resolve(component, selectors \\ [])
  def resolve(component, :base), do: add_base([], component) |> merge

  def resolve(component, selectors) when is_list(selectors) do
    variants = Map.get(component, :variants, %{})
    default_variants = Map.get(component, :default_variants, [])
    option_variants = option_variants(variants)
    boolean_variants = boolean_variants(variants)
    compound_variants = Map.get(component, :compound_variants, [])
    override = Keyword.get(selectors, :class, [])

    selectors = selectors |> Enum.reject(fn {_k, v} -> is_nil(v) end) |> then(&Keyword.merge(default_variants, &1))

    add_base(component)
    |> handle_option_variants(option_variants, selectors)
    |> handle_boolean_variants(boolean_variants, selectors)
    |> handle_override(override)
    |> handle_compound_variants(compound_variants, selectors)
    |> List.flatten()
    |> Enum.reverse()
    |> merge()
  end

  defp option_variants(variant) do
    variant
    |> Enum.reject(fn {_category, values} ->
      Enum.all?(values, fn {k, _v} -> is_boolean(k) end)
    end)
  end

  defp boolean_variants(variant) do
    variant
    |> Enum.filter(fn {_category, values} ->
      Enum.all?(values, fn {k, _v} -> is_boolean(k) end)
    end)
  end

  defp add_base(acc \\ [], component)
  defp add_base(acc, %{base: base}), do: [base | acc]
  defp add_base(acc, _component), do: acc

  defp handle_option_variants(acc, [], _selectors), do: acc

  defp handle_option_variants(acc, option_variants, selectors) do
    result =
      selectors
      |> transform_selectors()
      |> get_in_option_variant(option_variants)

    [result | acc]
  end

  defp transform_selectors(selectors) when is_atom(selectors), do: List.wrap(selectors)

  defp transform_selectors(selectors) when is_list(selectors) do
    selectors
    |> Enum.reject(fn {k, _v} -> k == :class end)
    |> Enum.map(fn {k, v} ->
      k = if is_binary(k), do: String.to_existing_atom(k), else: k
      v = if is_binary(v), do: String.to_existing_atom(v), else: v
      [k, v]
    end)
  end

  defp get_in_option_variant(selectors, variant, opts \\ [])

  defp get_in_option_variant(selectors, variant, opts) when is_list(selectors) do
    slot = Keyword.get(opts, :slot)

    Enum.reduce(selectors, [], fn selector, acc ->
      full_path = if slot, do: selector ++ slot, else: selector

      [get_in(variant, full_path) | acc]
    end)
    |> List.flatten()
    |> Enum.sort()
  end

  defp handle_boolean_variants(acc, [], _selectors), do: acc

  defp handle_boolean_variants(acc, boolean_variants, selectors) do
    Enum.reduce(boolean_variants, acc, fn {category, values}, acc ->
      value = if Keyword.get(selectors, category, false) == true, do: Map.get(values, true, []), else: Map.get(values, false, [])
      [value | acc]
    end)
  end

  defp handle_compound_variants(acc, [], _selectors), do: acc

  defp handle_compound_variants(acc, compound_variants, selectors) do
    Enum.reduce(compound_variants, acc, fn variant, acc ->
      hit? =
        variant
        |> Enum.reject(fn {k, _v} -> k == :class end)
        |> Enum.all?(fn {k, v} ->
          Keyword.get(selectors, k) == v
        end)

      if hit?, do: [Map.get(variant, :class) | acc], else: acc
    end)
  end

  defp handle_override(acc, override) do
    [override | acc]
  end
end
