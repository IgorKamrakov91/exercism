defmodule React do
  @moduledoc false
  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  # GenServer API

  def init(cells) do
    {:ok, %{cells: cells, callbacks: %{}}}
  end

  @doc """
  Start a reactive system
  """
  @spec new([cell]) :: {:ok, pid}
  def new(cells), do: GenServer.start(__MODULE__, cells)

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(pid, String.t()) :: any()
  def get_value(cells, cell_name), do: GenServer.call(cells, {:get_value, cell_name})

  @doc """
  Set the value of an input cell
  """
  @spec set_value(pid, String.t(), any) :: :ok
  def set_value(cells, cell_name, value), do: GenServer.call(cells, {:set_value, cell_name, value})

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.call(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.call(cells, {:remove_callback, cell_name, callback_name})
  end

  # GenServer Callbacks

  def handle_call({:get_value, cell_name}, _from, %{cells: cells} = state) do
    cell = find_cell(cells, cell_name)
    {:reply, cell_value(cell, cells), state}
  end

  def handle_call({:set_value, cell_name, value}, _from, %{cells: cells, callbacks: callbacks} = state) do
    new_cells =
      Enum.map(cells, fn
        {:input, ^cell_name, _} -> {:input, cell_name, value}
        other -> other
      end)

    fire_callbacks_for_change(cell_name, cells, new_cells, callbacks)
    {:reply, :ok, %{state | cells: new_cells}}
  end

  def handle_call({:add_callback, cell_name, callback_name, callback}, _from, %{callbacks: callbacks} = state) do
    new_callbacks =
      Map.update(callbacks, cell_name, %{callback_name => callback}, fn cell_callbacks ->
        Map.put(cell_callbacks, callback_name, callback)
      end)

    {:reply, :ok, %{state | callbacks: new_callbacks}}
  end

  def handle_call({:remove_callback, cell_name, callback_name}, _from, %{callbacks: callbacks} = state) do
    new_callbacks =
      case Map.get(callbacks, cell_name) do
        nil -> callbacks
        cell_callbacks ->
          updated = Map.delete(cell_callbacks, callback_name)
          if map_size(updated) == 0, do: Map.delete(callbacks, cell_name), else: Map.put(callbacks, cell_name, updated)
      end

    {:reply, :ok, %{state | callbacks: new_callbacks}}
  end

  # Helpers

  defp find_cell(cells, cell_name) do
    Enum.find(cells, fn
      {:input, name, _} -> name == cell_name
      {:output, name, _, _} -> name == cell_name
    end)
  end

  defp cell_value({:input, _name, value}, _cells), do: value
  defp cell_value({:output, _name, deps, func}, cells) do
    dep_values = Enum.map(deps, &cell_value(find_cell(cells, &1), cells))
    apply(func, dep_values)
  end

  defp fire_callbacks_for_change(changed_cell_name, old_cells, new_cells, callbacks) do
    affected = affected_output_cells(changed_cell_name, new_cells)

    Enum.each(affected, fn cell_name ->
      old_val = output_cell_value(cell_name, old_cells)
      new_val = output_cell_value(cell_name, new_cells)
      if old_val != new_val, do: fire_callbacks(cell_name, new_val, callbacks)
    end)
  end

  defp affected_output_cells(changed_cell_name, cells) do
    output_names =
      for {:output, name, _, _} <- cells, do: name

    find_transitive_dependents(changed_cell_name, output_names, cells, MapSet.new())
    |> MapSet.to_list()
  end

  defp find_transitive_dependents(target, candidates, cells, visited) do
    Enum.reduce(candidates, visited, fn candidate, acc ->
      if MapSet.member?(acc, candidate) do
        acc
      else
        case find_cell(cells, candidate) do
          {:output, _name, deps, _func} ->
            if target in deps do
              acc = MapSet.put(acc, candidate)
              rest = candidates -- [candidate]
              find_transitive_dependents(candidate, rest, cells, acc)
            else
              acc
            end
          _ -> acc
        end
      end
    end)
  end

  defp output_cell_value(cell_name, cells) do
    cell = find_cell(cells, cell_name)
    cell_value(cell, cells)
  end

  defp fire_callbacks(cell_name, new_value, callbacks) do
    case Map.get(callbacks, cell_name) do
      nil -> :ok
      cell_callbacks ->
        Enum.each(cell_callbacks, fn {cb_name, cb_fun} -> cb_fun.(cb_name, new_value) end)
    end
  end
end
