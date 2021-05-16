defmodule SimpleTodoCliTest do
  use ExUnit.Case
  doctest SimpleTodoCli

  test "greets the world" do
    assert SimpleTodoCli.hello() == :world
  end
end
