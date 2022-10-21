defmodule Helpers.Flatter do
  import Helpers.Keys

  @default_key_format :keep
  @default_delimeter "."

  def flatten(m, opts \\ [delimeter: @default_delimeter, key: @default_key_format])

  def flatten(m, opts) do
    {delimeter, key_format} = extract_options(opts)

    flat_map(m, delimeter, key_format)
  end

  @moduledoc false
  def flat_map(m, delimeter, key_format) when is_struct(m) do
    m
    |> Map.from_struct()
    |> flat_map(delimeter, key_format)
  end

  def flat_map(m, delimeter, key_format) when is_map(m) do
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

  def flat_map(v, _delimeter, _key), do: [v]

  defp extract_options(delimeter: delimeter), do: {delimeter, @default_key_format}
  defp extract_options(key: key), do: {@default_delimeter, key}
  defp extract_options(delimeter: delimeter, key: key), do: {delimeter, key}
end
