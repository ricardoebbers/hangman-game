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

    test "should recognize a letter in the word" do
      game = Game.new("wombat")
      {game, _tally} = Game.make_move(game, "w")

      assert game.used == MapSet.new(["w"])
      assert game.state == :good_guess
    end

    test "should return :bad_guess" do
      game = Game.new("wombat")
      {game, _tally} = Game.make_move(game, "z")
      assert game.state == :bad_guess
    end

    test "should subtract a turn when a bad guess is made" do
      game = Game.new("wombat")
      {new_game, _tally} = Game.make_move(game, "z")
      assert game.turns_left - 1 == new_game.turns_left
    end

    test "should handle a winning sequence of moves" do
      "hello"
      |> test_sequence_of_moves([
        ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
        ["x", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "x"]],
        ["a", :already_used, 5, ["_", "_", "_", "_", "_"], ["a", "x"]],
        ["e", :good_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
        ["f", :bad_guess, 4, ["_", "e", "_", "_", "_"], ["a", "e", "f", "x"]],
        ["h", :good_guess, 4, ["h", "e", "_", "_", "_"], ["a", "e", "f", "h", "x"]],
        ["l", :good_guess, 4, ["h", "e", "l", "l", "_"], ["a", "e", "f", "h", "l", "x"]],
        ["o", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "f", "h", "l", "o", "x"]]
      ])
    end

    test "should handle a sequence of moves" do
      "helwo"
      |> test_sequence_of_moves([
        ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
        ["x", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "x"]],
        ["a", :already_used, 5, ["_", "_", "_", "_", "_"], ["a", "x"]],
        ["e", :good_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
        ["f", :bad_guess, 4, ["_", "e", "_", "_", "_"], ["a", "e", "f", "x"]],
        ["h", :good_guess, 4, ["h", "e", "_", "_", "_"], ["a", "e", "f", "h", "x"]],
        ["u", :bad_guess, 3, ["h", "e", "_", "_", "_"], ["a", "e", "f", "h", "u", "x"]],
        ["q", :bad_guess, 2, ["h", "e", "_", "_", "_"], ["a", "e", "f", "h", "q", "u", "x"]],
        ["t", :bad_guess, 1, ["h", "e", "_", "_", "_"], ["a", "e", "f", "h", "q", "t", "u", "x"]],
        ["z", :lost, 0, ["h", "e", "l", "w", "o"], ["a", "e", "f", "h", "q", "t", "u", "x", "z"]]
      ])
    end
  end

  defp test_sequence_of_moves(word, script) do
    game = Game.new(word)
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert state == tally.game_state
    assert turns_left == tally.turns_left
    assert letters == tally.letters
    assert used == tally.used

    game
  end
end
