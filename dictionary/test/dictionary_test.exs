defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "should fetch a random word from the list" do
    assert is_binary(Dictionary.random_word())
  end
end
