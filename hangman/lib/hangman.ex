defmodule Hangman do
  alias Hangman.Impl.Game

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @opaque game :: Game.t()
  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  @spec new_game() :: game
  defdelegate new_game, to: Game, as: :new

  @spec make_move(game, String.t()) :: {game, tally}
  def make_move(game, guess) do
  end
end
