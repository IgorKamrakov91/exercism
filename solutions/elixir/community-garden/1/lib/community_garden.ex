# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn ->
      %{plots: opts, next_id: 1}
    end)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn %{plots: plots} -> plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn %{plots: plots, next_id: next_id} ->
      plot = %Plot{plot_id: next_id, registered_to: register_to}
      new_state = %{plots: [plot | plots], next_id: next_id + 1}
      {plot, new_state}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn %{plots: plots, next_id: next_id} ->
      updated_plots = Enum.reject(plots, fn plot -> plot.plot_id == plot_id end)
      %{plots: updated_plots, next_id: next_id}
    end)

    :ok
  end

  def get_registration(pid, plot_id) do
    result = list_registrations(pid) |> Enum.find(&(&1.plot_id == plot_id))

    case result do
      %Plot{} ->
        result

      nil ->
        {:not_found, "plot is unregistered"}
    end
  end
end
