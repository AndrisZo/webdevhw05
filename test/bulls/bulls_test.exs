defmodule Bulls.BullsTest do
  use ExUnit.Case
  import Bulls.Game

  #test "Random digits are random" do
  #  assert [1, 2, 3, 4] == random_digits()
  #end

  test "Test cows_bulls" do
    assert cows_bulls([1, 2, 3, 4], [1, 2, 3, 4]) == {0, 4}
    assert cows_bulls([1, 2, 3, 4], [2, 3, 4, 1]) == {4, 0}
    assert cows_bulls([1, 2, 3, 4], [5, 6, 7, 8]) == {0, 0}
    assert cows_bulls([5, 6, 7, 8], [1, 6, 5, 2]) == {1, 1}
  end

  test "test all_cows_bulls" do
    assert all_cows_bulls([[1, 2, 3, 4], [2, 3, 4, 1], [5, 6, 7, 8]], [1, 2, 3, 4]) == [{0, 4}, {4, 0}, {0, 0}]
    assert all_cows_bulls([[1, 2, 3, 4], [2, 3, 4, 1], [5, 6, 7, 8]], [1, 2, 3, 4]) == [{0, 4}, {4, 0}, {0, 0}]
  end

  test "make guess" do
    # Branch one, gamestate is win
    statewin1 =  %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "win"}
    guesswin1 = [7, 8, 9, 5]
    resultwin1 =  %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "win"}

    #Branch one, gamestate is lose
    statelose1 = %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 4], feedback: "", gamestate: "lose"}
    guesslose1 = [1, 2, 3, 4]
    resultlose1 = %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 4], feedback: "", gamestate: "lose"}

    # Branch 2, 8 guesses already
    state2 = %{guesses: [1, 2, 3, 4, 5, 6, 7, 8, 9], digits: [1, 2, 3, 4], feedback: "", gamestate: "guessing"}
    guess2 = [1, 2, 3, 4]
    result2 =  %{guesses: [1, 2, 3, 4, 5, 6, 7, 8, 9], digits: [1, 2, 3, 4], feedback: "", gamestate: "lose"}


    # Branch 3, correct guess already
    state3 = %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 4], feedback: "", gamestate: "guessing"}
    guess3 = [7, 8, 9, 1]
    result3 = %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 4], feedback: "", gamestate: "win"}

    # Branch 4, this is the correct guess
    state4 = %{guesses: [], digits: [1, 2, 3, 4], feedback: "", gamestate: "guessing"}
    guess4 = [1, 2, 3, 4]
    result4 = %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 4], feedback: "", gamestate: "win"}

    # Branch 5, they guess an incorrect 8th guess
    state5 = %{guesses: [1, 2, 3, 4, 5, 6, 7], digits: [1, 2, 3, 4], feedback: "", gamestate: "guessing"}
    guess5 = [1, 2, 3, 5]
    result5 = %{guesses: [[1, 2, 3, 5], 1, 2, 3, 4, 5, 6, 7], digits: [1, 2, 3, 4], feedback: "", gamestate: "lose"}

    # Branch 6, they make a normal guess
    state6 =  %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "guessing"}
    guess6 = [5, 6, 7, 8]
    result6 =  %{guesses: [[5, 6, 7, 8], [1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "guessing"}

    # Branch 7, they make a guess that isn't 4 unique numbers
    state7 =  %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "guessing"}
    guess7 = [5, 6, 7, 7]
    result7 =  %{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "Guesses must be 4 unique numbers", gamestate: "guessing"}

    assert guess(statewin1, guesswin1) == resultwin1
    assert guess(statelose1, guesslose1) == resultlose1
    assert guess(state2, guess2) == result2
    assert guess(state3, guess3) == result3
    assert guess(state4, guess4) == result4
    assert guess(state5, guess5) == result5
    assert guess(state6, guess6) == result6
    assert guess(state7, guess7) == result7
  end

  test "get view" do
    assert view(%{guesses: [[1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "win"}) ==
      %{guesses: [[1, 2, 3, 4]], cowbull: [{0, 3}], feedback: "", gamestate: "win"}

    assert view(%{guesses: [[5, 6, 7, 8], [1, 2, 3, 4]], digits: [1, 2, 3, 5], feedback: "", gamestate: "guessing"}) ==
      %{guesses: [[5, 6, 7, 8], [1, 2, 3, 4]], cowbull: [{1, 0}, {0, 3}], feedback: "", gamestate: "guessing"}
  end
end
