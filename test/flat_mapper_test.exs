defmodule FlatMapperTest do
  @moduledoc false
  use ExUnit.Case
  doctest FlatMapper

  test "flatten/2 for maps" do
    input = %{
      "a" => "foo",
      "b" => %{
        "bar" => "baz"
      }
    }

    expected = %{
      "a" => "foo",
      "b.bar" => "baz"
    }

    result = FlatMapper.flatten(input)

    assert expected == result
  end
end
