defmodule CircularBuffer do
  use GenServer

  alias CircularBuffer

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  defstruct items: [], capacity: 0, count: 0

  def init(capacity) do
    {:ok, %CircularBuffer{capacity: capacity}}
  end

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start(CircularBuffer, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.cast(buffer, :clear)
  end

  # callbacks

  def handle_call(:read, _from, %CircularBuffer{items: [], count: 0} = state) do
    {:reply, {:error, :empty}, state}
  end

  def handle_call(:read, _from, %CircularBuffer{items: [item | rest], count: count} = state) do
    new_state = %{state | items: rest, count: count - 1}
    {:reply, {:ok, item}, new_state}
  end

  def handle_call(
        {:write, item},
        _from,
        %CircularBuffer{count: count, capacity: capacity} = state
      )
      when count < capacity do
    new_state = %{state | items: state.items ++ [item], count: count + 1}
    {:reply, :ok, new_state}
  end

  def handle_call(
        {:write, _item},
        _from,
        %CircularBuffer{count: count, capacity: capacity} = state
      )
      when count >= capacity do
    {:reply, {:error, :full}, state}
  end

  def handle_call(
        {:overwrite, item},
        _from,
        %CircularBuffer{count: count, capacity: capacity} = state
      )
      when count < capacity do
    new_state = %{state | items: state.items ++ [item], count: count + 1}
    {:reply, :ok, new_state}
  end

  def handle_call(
        {:overwrite, item},
        _from,
        %CircularBuffer{items: [_oldest | rest], count: _count} = state
      ) do
    new_state = %{state | items: rest ++ [item]}
    {:reply, :ok, new_state}
  end

  def handle_cast(:clear, %CircularBuffer{capacity: capacity}) do
    {:noreply, %CircularBuffer{capacity: capacity}}
  end
end
