defmodule Turboprop.Variants do
  import Turboprop.Merge

  def component(input) do
    input
  end

  def resolve(component, selectors \\ [])
  def resolve(component, :base), do: add_base([], component, :base) |> merge

  def resolve(component, selectors) when is_list(selectors) do
    variants = Map.get(component, :variants, %{})
    default_variants = Map.get(component, :default_variants, [])
    option_variants = option_variants(variants)
    boolean_variants = boolean_variants(variants)
    compound_variants = Map.get(component, :compound_variants, [])
    {override, selectors} = Keyword.pop(selectors, :class, [])
    {slot, selectors} = Keyword.pop(selectors, :slot, :base)

    selectors = selectors |> Enum.reject(fn {_k, v} -> is_nil(v) end) |> then(&Keyword.merge(default_variants, &1))

    add_base(component, slot)
    |> handle_option_variants(option_variants, selectors, slot)
    |> handle_boolean_variants(boolean_variants, selectors, slot)
    |> handle_override(override)
    |> handle_compound_variants(compound_variants, selectors, slot)
    |> Enum.reverse()
    |> List.flatten()
    |> merge()
  end

  defp option_variants(variant) do
    variant
    |> Enum.reject(fn {_category, values} ->
      Enum.all?(values, fn {k, _v} -> is_boolean(k) end)
    end)
    |> Map.new()
  end

  defp boolean_variants(variant) do
    variant
    |> Enum.filter(fn {_category, values} ->
      Enum.all?(values, fn {k, _v} -> is_boolean(k) end)
    end)
    |> Map.new()
  end

  defp add_base(acc \\ [], component, slot)
  defp add_base(acc, %{base: base}, :base), do: [base | acc]

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
    |> Enum.reject(fn {k, _v} -> k == :class end)
    |> Enum.map(fn {k, v} ->
      k = if is_binary(k), do: String.to_existing_atom(k), else: k
      v = if is_binary(v), do: String.to_existing_atom(v), else: v
      [k, v]
    end)
  end

  defp get_in_option_variant(selectors, variant, slot)

  defp get_in_option_variant(selectors, variant, slot) when is_list(selectors) do
    Enum.reduce(selectors, [], fn selector, acc ->
      value =
        if slot == :base,
          do: fetch_nested(variant, selector ++ [:base]) || fetch_nested(variant, selector),
          else: fetch_nested(variant, selector ++ [slot])

      [value | acc]
    end)
    |> List.flatten()
    |> Enum.sort()
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
    Map.get(values, option) || fetch_nested(values, [option, :base])
  end

  defp get_value_for_boolean(values, option, slot) do
    fetch_nested(values, [option, slot])
  end

  defp handle_compound_variants(acc, [], _selectors, _slot), do: acc

  defp handle_compound_variants(acc, compound_variants, selectors, _slot) do
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

  defp fetch_nested(current_value, []) when is_binary(current_value) or is_list(current_value), do: current_value
  defp fetch_nested(_current_value, []), do: nil

  defp fetch_nested(current_value, [key | rest]) do
    if is_map(current_value) and Map.has_key?(current_value, key) do
      fetch_nested(current_value[key], rest)
    else
      nil
    end
  end
end
