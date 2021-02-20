defmodule Bulls.Game do
  def new do
    %{
      digits: random_digits(),
      guesses: [],
      feedback: "",
      gamestate: "guessing"
    }
  end

  def guess(state, guess) do
    cond do
      state.gamestate == "lose" or state.gamestate == "win" ->
        %{
          digits: state.digits,
          guesses: state.guesses,
          feedback: "",
          gamestate: state.gamestate
        }
      Enum.count(state.guesses) >= 8 ->
        %{
          digits: state.digits,
          guesses: state.guesses,
          feedback: "",
          gamestate: "lose"
        }
      Enum.member?(state.guesses, state.digits) ->
        %{
          digits: state.digits,
          guesses: state.guesses,
          feedback: "",
          gamestate: "win"
        }
      Enum.count(guess) != 4 or Enum.uniq(guess) != guess ->
        %{
          digits: state.digits,
          guesses: state.guesses,
          feedback: "Guesses must be 4 unique numbers",
          gamestate: "guessing"
        }
      guess == state.digits ->
        %{
          digits: state.digits,
          guesses: [guess | state.guesses],
          feedback: "",
          gamestate: "win",
        }
      Enum.count([guess | state.guesses]) >=8 ->
        %{
          digits: state.digits,
          guesses: [guess | state.guesses],
          feedback: "",
          gamestate: "lose"
        }
      true ->
        %{
          digits: state.digits,
          guesses: [guess | state.guesses],
          feedback: "",
          gamestate: state.gamestate
        }
      true ->

    end
  end

  def random_digits() do
    get_digits(4, [], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  def get_digits(numdigits, digits, avail) do
    cond do
      numdigits <= 0 -> digits
      numdigits > 0 ->
        {adddigit, newavail} = List.pop_at(avail, :rand.uniform(Enum.count(avail) - 1))
        get_digits(numdigits - 1, [adddigit | digits], newavail)
    end
  end

  def all_cows_bulls(guesses, digits) do
    Enum.map(guesses, fn guess -> cows_bulls(guess, digits) end)
  end

  def cows_bulls(guess, digits) do
    cows_bulls(guess, digits, digits, 0, 0)
  end

  def cows_bulls(guessrem, digitsrem, digits, cows, bulls) do
    cond do
      Enum.empty?(guessrem) -> [cows, bulls]
      hd(guessrem) == hd(digitsrem) -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows, bulls + 1)
      Enum.member?(digits, hd(guessrem)) -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows + 1, bulls)
      true -> cows_bulls(tl(guessrem), tl(digitsrem), digits, cows, bulls)
    end
  end

  def view(state) do
    %{
      guesses: state.guesses,
      cowbull: all_cows_bulls(state.guesses, state.digits),
      feedback: state.feedback,
      gamestate: state.gamestate
    }
  end


end
