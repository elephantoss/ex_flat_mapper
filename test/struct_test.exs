defmodule StructTest do
  @moduledoc false
  use ExUnit.Case

  import FlatMapper
  alias StructTest.Flat, as: FS
  alias StructTest.OneLevel, as: OL
  alias StructTest.TwoLevels, as: TL

  describe "flatten/2" do
    test "convert a flat struct to a map" do
      input = %FS{
        a: "foo",
        b: "bar"
      }

      expected = %{
        a: "foo",
        b: "bar"
      }

      result = flatten(input)

      assert expected == result
    end

    test "flat 2 levels structs into a map" do
      input = %OL{
        a: "foo",
        b: %FS{
          a: "bar",
          b: "baz"
        }
      }

      expected = %{
        a: "foo",
        b_a: "bar",
        b_b: "baz"
      }

      result = flatten(input, delimeter: "_")

      assert expected == result
    end

    test "flat 3 levels structs into a map" do
      input = %TL{
        a: "foo",
        b: %OL{
          a: "bar",
          b: %FS{
            a: "baz",
            b: "qux"
          }
        }
      }

      expected = %{
        a: "foo",
        b_a: "bar",
        b_b_a: "baz",
        b_b_b: "qux"
      }

      result = flatten(input, delimeter: "_")

      assert expected == result
    end

    test "convert keys to strings" do
      input = %TL{
        a: "foo",
        b: %OL{
          a: "bar",
          b: %FS{
            a: "baz",
            b: "qux"
          }
        }
      }

      expected = %{
        "a" => "foo",
        "b.a" => "bar",
        "b.b.a" => "baz",
        "b.b.b" => "qux"
      }

      result = flatten(input, delimeter: ".", key: :as_string)

      assert expected == result
    end

    test "change delimeter from . to _ when keys are atoms" do
      input = %OL{
        a: "foo",
        b: %FS{
          a: "bar",
          b: "baz"
        }
      }

      expected = %{
        a: "foo",
        b_a: "bar",
        b_b: "baz"
      }

      result = flatten(input, delimeter: ".", key: :as_atom)

      assert expected == result
    end
  end

  describe "remove keys included in the exclusion list" do
    test "remove atom keys" do
      input = %TL{
        a: "foo",
        b: %OL{
          a: "bar",
          b: %FS{
            a: "baz",
            b: "qux"
          }
        }
      }

      expected = %{
        b_b_b: "qux"
      }

      result = flatten(input, delimeter: "_", exclude: [:a])

      assert expected == result
    end
  end
end
