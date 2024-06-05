defmodule Turboprop.Merge do
  @moduledoc """
  Utilities for joining and merging Tailwind classes.
  """

  alias Turboprop.Merge.Config
  alias Turboprop.Merge.Cache
  alias Turboprop.Merge.Class

  @doc """
  Joins and merges a list of classes.
  """
  def merge(input, config \\ Config.config()) do
    input
    |> join()
    |> retrieve_from_cache_or_merge(config)
  end

  @doc """
  Joins a list of classes.
  """
  def join(input) when is_binary(input), do: input
  def join(input) when is_list(input), do: do_join(input, "")
  def join(_), do: ""

  defp do_join([], result), do: result

  defp do_join([head | tail], result) do
    case to_value(head) do
      "" -> do_join(tail, result)
      value when result == "" -> do_join(tail, value)
      value -> do_join(tail, result <> " " <> value)
    end
  end

  defp to_value(value) when is_binary(value), do: value

  defp to_value(values) when is_list(values) do
    Enum.reduce(values, "", fn v, acc ->
      case to_value(v) do
        "" -> acc
        resolved_value when acc == "" -> resolved_value
        resolved_value -> acc <> " " <> resolved_value
      end
    end)
  end

  defp to_value(_), do: ""

  defp retrieve_from_cache_or_merge(classes, config) do
    case Cache.get("merge:#{classes}") do
      :not_found ->
        merged_classes = do_merge(classes, config)
        Cache.put("merge:#{classes}", merged_classes)
        merged_classes

      merged_classes ->
        merged_classes
    end
  end

  defp do_merge(classes, config) do
    classes
    |> String.trim()
    |> String.split(~r/\s+/)
    |> Enum.map(&Class.parse/1)
    |> Enum.reverse()
    |> Enum.reduce(%{classes: [], groups: []}, fn class, acc ->
      handle_class(class, acc, config)
    end)
    |> Map.get(:classes)
    |> Enum.join(" ")
  end

  defp handle_class(%{raw: raw, tailwind?: false}, acc, _config),
    do: Map.update!(acc, :classes, fn classes -> [raw | classes] end)

  defp handle_class(%{conflict_id: conflict_id} = class, acc, config) do
    if Enum.member?(acc.groups, conflict_id), do: acc, else: add_class(acc, class, config)
  end

  defp add_class(acc, %{raw: raw, group: group, conflict_id: conflict_id, modifier_id: modifier_id}, config) do
    conflicting_groups =
      group
      |> conflicting_groups(config)
      |> Enum.map(&"#{modifier_id}:#{&1}")
      |> then(&[conflict_id | &1])

    acc
    |> Map.update!(:classes, fn classes -> [raw | classes] end)
    |> Map.update!(:groups, fn groups -> groups ++ conflicting_groups end)
  end

  defp conflicting_groups(group, config) do
    conflicts = Map.get(config.conflicting_groups, group, [])
    modifier_conflicts = Map.get(config.conflicting_group_modifiers, group, [])

    conflicts ++ modifier_conflicts
  end
end
