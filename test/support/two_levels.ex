defmodule StructTest.TwoLevels do
  @moduledoc false
  defstruct a: :string, b: StructTest.OneLevel
end
