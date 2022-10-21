defmodule FlatMapper do
  @moduledoc """
  FlatMapper is a utility library that provides flatten functions for flattening
  maps and structs.

  This is a convenience module so one does not have to mind the specific type being
  flattened.
  """

  alias FlatMapper.Map

  @doc """
  Flattens the given value using the provided options.

  For more details, please check the documentation for the specific type.
  """
  def flatten(value, opts \\ [])
  def flatten(value, []) when is_map(value), do: Map.flatten(value)
  def flatten(value, opts) when is_map(value), do: Map.flatten(value, opts)
end
