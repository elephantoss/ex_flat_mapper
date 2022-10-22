defmodule FlatMapper do
  @moduledoc """
  FlatMapper is a utility library that provides flatten functions for flattening
  maps and structs.
  """

  alias Helpers.Flatter

  @doc """
  Flattens nested maps and structs, and uses the options provided to create the keys for the nested maps.

  ***Options:***

  delimeter -> character used to join the outer key and inner key when creating the key for
  nested maps.

  **key**:
    - `:keep` -> keep the type of the original key (string or atom)
    - `:as_string` -> keys of the resulting map will be strings
    - `:as_atom` -> keys of the resulting map will be atoms

  ***Important note:***

  When using `key: :as_atom`, flat map will override the delimeter to `_`, that's because
  Elixir does not support atoms with `.` and converts them to strings.

  This override mechanism is to prevent creating maps with two types of keys.

  ***Important note:***
  Calendar.ISO or ~N values are formatted as RFC3339z strings

  ## Examples

      iex> input = %{
      ...>    "a" => "foo",
      ...>    "b" => "bar"
      ...>  }
      iex> Helpers.Flatter.flatten(input)
      %{"a" => "foo", "b" => "bar"}

      iex> input = %{
      ...>    "a" => "foo",
      ...>    "b" => %{
      ...>      "bar" => "baz"
      ...>    }
      ...>  }
      iex> Helpers.Flatter.flatten(input)
      %{"a" => "foo", "b.bar" => "baz"}

      iex> input = %StructTest.Flat{
      ...>    a: "foo",
      ...>    b: "bar"
      ...>  }
      iex> Helpers.Flatter.flatten(input)
      %{a: "foo", b: "bar"}
  """
  def flatten(value, opts \\ [])
  def flatten(value, []), do: Flatter.flatten(value)
  def flatten(value, opts), do: Flatter.flatten(value, opts)
end
