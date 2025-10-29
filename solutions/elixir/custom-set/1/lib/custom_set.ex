defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: %{}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %CustomSet{map: enumerable |> Stream.map(&{&1, :ok}) |> Map.new()}
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    custom_set.map == %{}
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    custom_set.map |> Map.get(element) == :ok
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    custom_set_1.map |> Map.keys() |> Enum.all?(&contains?(custom_set_2, &1))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    custom_set_2.map |> Map.keys() |> Enum.all?(&(not contains?(custom_set_1, &1)))
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    custom_set_1.map == custom_set_2.map
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    custom_set.map |> Map.put(element, :ok) |> Map.keys() |> new()
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    custom_set_1.map |> Map.keys() |> Enum.filter(&contains?(custom_set_2, &1)) |> new()
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    custom_set_1.map |> Map.keys() |> Enum.reject(&contains?(custom_set_2, &1)) |> new()
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    custom_set_1.map |> Map.merge(custom_set_2.map) |> Map.keys() |> new()
  end
end
