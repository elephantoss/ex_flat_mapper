defmodule Helpers.Keys do
  @moduledoc false
  def make_key(k, :keep), do: k
  def make_key(k, :as_string), do: to_string(k)
  def make_key(k, :as_atom) when not is_atom(k), do: String.to_atom(k)
  def make_key(k, :as_atom), do: k

  def make_key(prefix, delimeter, suffix, :as_string), do: prefix <> delimeter <> suffix

  def make_key(prefix, delimeter, suffix, format) do
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
end
