defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new() :: t
  def new, do: new(Dictionary.random_word())

  @spec new(String.t()) :: t
  def new(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(game = %{state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, _already_used = true), do: %{game | state: :already_used}

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp tally(game),
    do: %{
      turns_left: game.turns_left,
      game_state: game.state,
      letters: [],
      used: game.used |> MapSet.to_list()
    }
end
