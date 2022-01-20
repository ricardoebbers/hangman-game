defmodule TextClient.Impl.Player do
  @type game :: Hangman.game()
  @type tally :: Hangman.tally()
  @type state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  # @type state ::
  #         :initializing
  #         | :good_guess
  #         | :bad_guess
  #         | :already_used

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations, You won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join()}")
  end

  def interact({_game, tally}) do
    IO.puts(feedback_for(tally))
    # feedback
    # display current word
    # get next guess
    # make move
    # interact()
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    IO.puts("Welcome! I'm thinking of a #{tally.letters |> length} letter word.")
  end

  defp feedback_for(%{game_state: :bad_guess}) do
    IO.puts("Sorry, that letter's not in the word...")
  end

  defp feedback_for(%{game_state: :good_guess}) do
    IO.puts("Good guess!")
  end

  defp feedback_for(%{game_state: :already_used}) do
    IO.puts("You already used that letter.")
  end
end
