defmodule TextClient.Impl.Player do
  @type game :: Hangman.game()
  @type tally :: Hangman.tally()
  @type state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
    :ok
  end

  @spec interact(state) :: tally
  def interact({_game, tally = %{game_state: :won}}) do
    IO.puts("Congratulations, You won! The word was #{tally.letters |> Enum.join()}")
    tally
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... The word was #{tally.letters |> Enum.join()}")
    tally
  end

  def interact({game, tally}) do
    tally
    |> feedback_for()
    |> current_word()

    game
    |> Hangman.make_move(get_guess())
    |> interact()
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    IO.puts("Welcome! I'm thinking of a #{tally.letters |> length} letter word.")
    tally
  end

  defp feedback_for(tally = %{game_state: :bad_guess}) do
    IO.puts("Sorry, that letter's not in the word...")
    tally
  end

  defp feedback_for(tally = %{game_state: :good_guess}) do
    IO.puts("Good guess!")
    tally
  end

  defp feedback_for(tally = %{game_state: :already_used}) do
    IO.puts("You already used that letter.")
    tally
  end

  defp current_word(tally) do
    [
      "Word so far: #{tally.letters |> Enum.join(" ")}",
      "    Turns left: #{tally.turns_left |> to_string}",
      "    Used so far: #{tally.used |> Enum.join(", ")}"
    ]
    |> IO.puts()

    tally
  end

  defp get_guess() do
    "Next letter: "
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
  end
end
