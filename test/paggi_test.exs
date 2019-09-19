defmodule PaggiTest do
  use ExUnit.Case
  doctest Paggi

  test "greets the world" do
    assert Paggi.hello() == :world
  end
end
