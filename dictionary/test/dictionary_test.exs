defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "should fetch the word list" do
    assert is_list(Dictionary.word_list())
  end
end
