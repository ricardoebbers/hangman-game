defmodule Hangman do
  alias Hangman.Type
  alias Hangman.Impl.Game

   @opaque game :: Game.t()


  @spec new_game() :: game
  defdelegate new_game, to: Game, as: :new

  @spec make_move(game, String.t()) :: {game, Type.tally}
  def make_move(game, guess) do
    {game, guess}
  end
end
