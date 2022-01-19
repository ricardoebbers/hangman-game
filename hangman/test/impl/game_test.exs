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

    test "should return game with state :already_used when guessing same letter" do
      game = Game.new()
      {game, _tally} = Game.make_move(game, "x")
      assert game.state != :already_used
      {game, _tally} = Game.make_move(game, "x")
      assert game.state == :already_used
    end

    test "should record guessed letters" do
      game = Game.new()
      {game, _tally} = Game.make_move(game, "x")
      {game, _tally} = Game.make_move(game, "y")

      assert game.used == MapSet.new(["y", "x"])
    end
  end
end
