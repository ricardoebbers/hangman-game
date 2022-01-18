defmodule Dictionary do
  @word_list "assets/words.txt"
             |> File.read!()
             |> String.split(~r/\n/, trim: true)

  def random_word do
    Enum.random(@word_list)
  end
end
