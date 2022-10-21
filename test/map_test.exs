defmodule MapTest do
  @moduledoc false
  use ExUnit.Case

  import FlatMapper

  describe "flatten/2" do
    test "return the same map when given a non nested map" do
      input = %{
        "a" => "foo",
        "b" => "bar"
      }

      result = flatten(input, delimeter: ".")

      assert input == result
    end

    test "flat 2 levels maps" do
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

      result = flatten(input, delimeter: ".")

      assert expected == result
    end

    test "use the given delimeter" do
      input = %{
        "a" => "foo",
        "b" => %{
          "bar" => "baz"
        }
      }

      expected = %{
        "a" => "foo",
        "b_bar" => "baz"
      }

      result = flatten(input, delimeter: "_")

      assert expected == result
    end

    test "flat 3 levels maps" do
      input = %{
        "a" => "foo",
        "b" => %{
          "bar" => "baz"
        },
        "c" => %{
          "c1" => %{
            "qux" => "corge"
          }
        }
      }

      expected = %{
        "a" => "foo",
        "b.bar" => "baz",
        "c.c1.qux" => "corge"
      }

      result = flatten(input, delimeter: ".")

      assert expected == result
    end

    test "convert keys to strings" do
      input = %{
        a: "foo",
        b: %{
          bar: "baz"
        },
        c: %{
          c1: %{
            qux: "corge"
          }
        }
      }

      expected = %{
        "a" => "foo",
        "b.bar" => "baz",
        "c.c1.qux" => "corge"
      }

      result = flatten(input, delimeter: ".", key: :as_string)

      assert expected == result
    end

    test "keep type of original keys" do
      input = %{
        a: "foo",
        b: "bar"
      }

      expected = %{
        a: "foo",
        b: "bar"
      }

      result = flatten(input, delimeter: ".", key: :keep)

      assert expected == result
    end

    test "convert keys to atoms" do
      input = %{
        "a" => "foo",
        "b" => %{
          "bar" => "baz"
        },
        "c" => %{
          "c1" => %{
            "qux" => "corge"
          }
        }
      }

      expected = %{
        a: "foo",
        b_bar: "baz",
        c_c1_qux: "corge"
      }

      result = flatten(input, delimeter: "_", key: :as_atom)

      assert expected == result
    end

    test "convert keys to atoms change delimeter . to _" do
      input = %{
        "a" => "foo",
        "b" => %{
          "bar" => "baz"
        },
        "c" => %{
          "c1" => %{
            "qux" => "corge"
          }
        }
      }

      expected = %{
        a: "foo",
        b_bar: "baz",
        c_c1_qux: "corge"
      }

      result = flatten(input, delimeter: ".", key: :as_atom)

      assert expected == result
    end

    test "change delimeter from . to _ when keys are atoms" do
      input = %{
        a: "foo",
        b: %{
          bar: "baz"
        },
        c: %{
          c1: %{
            qux: "corge"
          }
        }
      }

      expected = %{
        a: "foo",
        b_bar: "baz",
        c_c1_qux: "corge"
      }

      result = flatten(input, delimeter: ".")

      assert expected == result
    end
  end
end
