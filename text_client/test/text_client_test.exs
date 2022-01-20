defmodule TextClientTest do
  use ExUnit.Case
  doctest TextClient

  describe "start/0" do
    test "should start a new game" do
      assert :ok = TextClient.start()
    end
  end
end
