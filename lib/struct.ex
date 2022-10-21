defmodule FlatMapper.Struct do
  @moduledoc """
  Implement flatten for Elixir structs.
  """

  @default_key_format :keep
  @default_delimeter "."

  @doc """
  Flattens nested structs and uses the options provided to create the keys for the nested maps.

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

  ## Examples

      iex> input = %StructTest.Flat{
      ...>    a: "foo",
      ...>    b: "bar"
      ...>  }
      iex> FlatMapper.Struct.flatten(input)
      %{a: "foo", b: "bar"}

  """
  def flatten(m, opts \\ [delimeter: @default_delimeter, key: @default_key_format])

  def flatten(m, opts) do
    {delimeter, key_format} = extract_options(opts)

    flat_map(m, delimeter, key_format)
  end

  defp flat_map(m, delimeter, key_format) when is_struct(m) do
    m
    |> Map.from_struct()
    |> flat_map(delimeter, key_format)
  end

  defp flat_map(m, delimeter, key_format) when is_map(m) do
    for {k, v} <- m,
        sk = make_key(k, key_format),
        fv <- flat_map(v, delimeter, key_format),
        into: %{} do
      case fv do
        {key, val} ->
          {make_key(sk, delimeter, key, key_format), val}

        val ->
          {sk, val}
      end
    end
  end

  defp flat_map(v, _delimeter, _key), do: [v]

  defp make_key(k, :keep), do: k
  defp make_key(k, :as_string), do: to_string(k)
  defp make_key(k, :as_atom) when not is_atom(k), do: String.to_atom(k)
  defp make_key(k, :as_atom), do: k

  defp make_key(prefix, delimeter, suffix, :as_string), do: prefix <> delimeter <> suffix

  defp make_key(prefix, delimeter, suffix, format) do
    {d, f} =
      if is_atom(prefix) || format == :as_atom do
        {"_", :as_atom}
      else
        {delimeter, :as_string}
      end

    [prefix, suffix]
    |> Enum.join(d)
    |> make_key(f)
  end

  defp extract_options(delimeter: delimeter), do: {delimeter, @default_key_format}
  defp extract_options(key: key), do: {@default_delimeter, key}
  defp extract_options(delimeter: delimeter, key: key), do: {delimeter, key}
end
