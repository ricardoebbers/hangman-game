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

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list()
    }
  end

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      game.letters
      |> MapSet.new()
      |> MapSet.subset?(game.used)
      |> maybe_won()

    %{game | state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _) do
    %{game | turns_left: game.turns_left - 1, state: :lost}
  end

  defp score_guess(game, _) do
    %{game | turns_left: game.turns_left - 1, state: :bad_guess}
  end

  defp maybe_won(_all_letters_guessed = true), do: :won
  defp maybe_won(_), do: :good_guess

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp reveal_guessed_letters(game = %{state: :lost}), do: game.letters

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(&maybe_reveal(&1, MapSet.member?(game.used, &1)))
  end

  defp maybe_reveal(letter, _member_of_word = true), do: letter
  defp maybe_reveal(_letter, _), do: "_"
end
