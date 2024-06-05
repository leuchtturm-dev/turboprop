defmodule Turboprop.Merge.Cache do
  @moduledoc false

  def get(key) do
    :persistent_term.get(key)
  rescue
    _ ->
      :not_found
  end

  def put(key, value) do
    :persistent_term.put(key, value)
  end
end
