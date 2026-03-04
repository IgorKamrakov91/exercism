defmodule Forth do
  alias Forth.StackOperation
  alias Forth.InvalidWord
  alias Forth.UnknownWord

  @type evaluator :: %__MODULE__{
          stack: Enum.t(),
          mode: atom,
          words: Map.t()
        }

  defstruct stack: [],
            mode: :eval,
            words: %{
              "+" => &StackOperation.add/1,
              "-" => &StackOperation.sub/1,
              "*" => &StackOperation.mul/1,
              "/" => &StackOperation.div/1,
              "dup" => &StackOperation.dup/1,
              "drop" => &StackOperation.drop/1,
              "swap" => &StackOperation.swap/1,
              "over" => &StackOperation.over/1
            }

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %Forth{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.downcase()
    |> String.split(~r/[[:space:]|[:cntrl:]]/u, trim: true)
    |> Enum.reduce(ev, &eval_elem/2)
  end

  defp eval_elem(x, %{stack: s, mode: m} = ev) do
    case {m, Integer.parse(x)} do
      {mode, number} when mode == :define_fn or number == :error ->
        eval_word(ev, x)

      {:eval, {number, _}} ->
        %{ev | stack: [number | s]}

      {:define, {_number, _}} ->
        raise InvalidWord
    end
  end

  defp eval_word(%{mode: :eval} = ev, ":") do
    %{ev | mode: :define}
  end

  defp eval_word(%{stack: [{word, func} | s], mode: :define_fn, words: w} = ev, ";") do
    eval_def = fn x ->
      func |> Enum.reverse() |> Enum.reduce(%{ev | stack: x, mode: :eval}, &eval_elem/2) |> Map.get(:stack)
    end

    %{ev | stack: s, mode: :eval, words: Map.put(w, word, eval_def)}
  end

  defp eval_word(%{stack: s, mode: :eval, words: w} = ev, word) do
    case w[word] do
      nil -> raise UnknownWord
      function -> %{ev | stack: function.(s)}
    end
  end

  defp eval_word(%{stack: s, mode: :define} = ev, word) do
    %{ev | stack: [{word, []} | s], mode: :define_fn}
  end

  defp eval_word(%{stack: [{new_word, func} | s], mode: :define_fn} = ev, word) do
    %{ev | stack: [{new_word, [word | func]} | s]}
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%{stack: s}) do
    s |> Enum.reverse() |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end

  defmodule StackOperation do
    alias Forth.StackUnderflow
    alias Forth.DivisionByZero

    def add([b, a | stack]), do: [a + b | stack]
    def add(_), do: raise(StackUnderflow)

    def sub([b, a | stack]), do: [a - b | stack]
    def sub(_), do: raise(StackUnderflow)

    def mul([b, a | stack]), do: [a * b | stack]
    def mul(_), do: raise(StackUnderflow)

    def div([0, _a | _]), do: raise(DivisionByZero)
    def div([b, a | stack]), do: [div(a, b) | stack]
    def div(_), do: raise(StackUnderflow)

    def dup([head | stack]), do: [head, head | stack]
    def dup(_), do: raise(StackUnderflow)

    def drop([_head | stack]), do: stack
    def drop(_), do: raise(StackUnderflow)

    def swap([b, a | stack]), do: [a, b | stack]
    def swap(_), do: raise(StackUnderflow)

    def over([_b, a | _] = stack), do: [a | stack]
    def over(_stack), do: raise(StackUnderflow)
  end
end
