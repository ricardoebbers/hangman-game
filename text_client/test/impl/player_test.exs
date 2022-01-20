defmodule TextClient.Impl.PlayerTest do
  use ExUnit.Case
  doctest TextClient

  alias TextClient.Impl.Player

  describe "start/0" do
    test "should start a new game" do
      assert :ok == Player.start()
    end
  end

  describe "interact/1" do
    test "should provide feedback on an initialized game" do
      
    end
  end
end
