defmodule Helpers.Flatter do
  @moduledoc false
  import Helpers.Keys

  @default_key_format :keep
  @default_delimeter "."

  def flatten(m, opts \\ [delimeter: @default_delimeter, key: @default_key_format])

  def flatten(m, opts) do
    {delimeter, key_format, exclude} = extract_options(opts)
    flat_map(m, delimeter, key_format, exclude)
  end

  def flat_map(m, delimeter, key_format, exclude) when is_struct(m) do
    m
    |> Map.from_struct()
    |> flat_map(delimeter, key_format, exclude)
  end

  def flat_map(%{calendar: Calendar.ISO} = m, _, _, _), do: [Timex.format!(m, "{RFC3339z}")]

  def flat_map(m, delimeter, key_format, exclude) when is_map(m) do
    for {k, v} <- m,
        Enum.any?(exclude, &(&1 == k)) == false,
        sk = make_key(k, key_format),
        fv <- flat_map(v, delimeter, key_format, exclude),
        into: %{} do
      case fv do
        {key, val} ->
          {make_key(sk, delimeter, key, key_format), val}

        val ->
          {sk, val}
      end
    end
  end

  def flat_map(v, _delimeter, _key, _exclude), do: [v]

  defp extract_options(opts) do
    delimeter = Keyword.get(opts, :delimeter, @default_delimeter)
    key_format = Keyword.get(opts, :key, @default_key_format)
    exclude = Keyword.get(opts, :exclude, [])

    {delimeter, key_format, exclude}
  end
end
