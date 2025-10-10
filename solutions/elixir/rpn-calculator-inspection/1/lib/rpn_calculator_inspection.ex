defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    {:ok, pid} = Task.start_link(__MODULE__, :run_calculator, [calculator, input])
    %{pid: pid, input: input}
  end

  def run_calculator(calculator, input) do
    calculator.(input)
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _reason} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(_calculator, []) do
    %{}
  end

  def reliability_check(calculator, inputs) do
    old_trap_exit = Process.flag(:trap_exit, true)

    try do
      check_data = Enum.map(inputs, &start_reliability_check(calculator, &1))
      Enum.reduce(check_data, %{}, &await_reliability_check_result/2)
    after
      Process.flag(:trap_exit, old_trap_exit)
    end
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
