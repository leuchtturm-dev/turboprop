defmodule Turboprop.Variants do
  import Turboprop.Merge

  def component(input) do
    input
  end

  def resolve(component, selectors \\ [])
  def resolve(component, :base), do: base(component) |> merge

  def resolve(component, selectors) when is_list(selectors) do
    base = base(component)
    variants = Map.get(component, :variants, %{})
    option_variants = option_variants(variants)
    boolean_variants = boolean_variants(variants)

    override = List.wrap(Keyword.get(selectors, :class, []))

    paths =
      transform_selectors(selectors)
      |> get_in_paths(option_variants)

    (base ++ paths ++ pull_boolean_variants(boolean_variants, selectors) ++ override)
    |> Turboprop.Merge.merge()
  end

  defp base(%{base: base}), do: List.wrap(base)
  defp base(_), do: []

  defp transform_selectors(variants) when is_atom(variants), do: List.wrap(variants)

  defp transform_selectors(variants) when is_list(variants) do
    variants
    |> Enum.reject(fn {k, _v} -> k == :class end)
    |> Enum.map(fn {k, v} ->
      k = if is_binary(k), do: String.to_existing_atom(k), else: k
      v = if is_binary(v), do: String.to_existing_atom(v), else: v
      [k, v]
    end)
  end

  defp get_in_paths(paths, variant, slot \\ nil)

  defp get_in_paths(paths, variant, slot) when is_list(paths) do
    Enum.reduce(paths, [], fn path, acc ->
      full_path = if slot, do: path ++ slot, else: path

      acc ++ List.wrap(get_in(variant, full_path))
    end)
    |> List.flatten()
    |> Enum.sort()
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

  defp pull_boolean_variants(variants, selectors) do
    Enum.reduce(variants, [], fn {category, values}, acc ->
      value = if Keyword.get(selectors, category, false) == true, do: Map.get(values, true, []), else: Map.get(values, false, [])
      acc ++ List.wrap(value)
    end)
  end
end
