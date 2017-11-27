defmodule ElavonTest do
  use ExUnit.Case
  doctest Elavon

  test "greets the world" do
    assert Elavon.hello() == :world
  end
end
