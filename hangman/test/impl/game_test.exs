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

    test "should return correct word" do
      word = "wombat"
      game = Game.new(word)
      assert game.letters == word |> String.codepoints()
    end
  end

  describe "" do
  end
end
