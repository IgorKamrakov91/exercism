defmodule TakeANumber do
  def start() do
    spawn(fn -> receiver(0) end)
  end

  defp receiver(state) do
    receive do
      {:report_state, sender} ->
        send(sender, state)
        receiver(state)

      {:take_a_number, sender} ->
        send(sender, state+1)
        receiver(state+1)

      :stop -> nil

      _ -> receiver(state)  
    end
  end
end
