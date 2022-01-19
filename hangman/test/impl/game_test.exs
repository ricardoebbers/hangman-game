defmodule Hangman.Impl.GameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  describe "new_game/0" do
    test "should return game state struct" do
      game = Game.new()
      assert game.turns_left == 7
      assert game.game_state == :initializing
      assert length(game.letters) > 0
    end
  end
end
