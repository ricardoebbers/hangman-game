defmodule Hangman.Impl.GameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  describe "new_game/0" do
    test "should return game state struct" do
      game = Game.new()
      assert game.turns_left == 7
      assert game.state == :initializing
      assert length(game.letters) > 0
    end

    test "should return correct word" do
      word = "wombat"
      game = Game.new(word)
      assert game.letters == word |> String.codepoints()
    end
  end

  describe "make_move/2" do
    test "should return same game when state is :won or :lost" do
      for state <- [:won, :lost] do
        game =
          "wombat"
          |> Game.new()
          |> Map.put(:state, state)

        {new_game, _tally} = Game.make_move(game, "x")
        assert game == new_game
      end

    end
  end
end
