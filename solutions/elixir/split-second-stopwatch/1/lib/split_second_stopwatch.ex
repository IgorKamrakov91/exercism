defmodule SplitSecondStopwatch do
  @doc """
  A stopwatch that can be used to track lap times.
  """

  @type state :: :ready | :running | :stopped

  defmodule Stopwatch do
    @type t :: :state | :current_lap | :previous_lap
    defstruct state: :ready, current_lap: Time.new!(0, 0, 0), previous_laps: []
  end

  @spec new() :: Stopwatch.t()
  def new() do
    %Stopwatch{}
  end

  @spec state(Stopwatch.t()) :: state()
  def state(stopwatch) do
    stopwatch.state
  end

  @spec current_lap(Stopwatch.t()) :: Time.t()
  def current_lap(stopwatch) do
    stopwatch.current_lap
  end

  @spec previous_laps(Stopwatch.t()) :: [Time.t()]
  def previous_laps(stopwatch) do
    stopwatch.previous_laps |> Enum.reverse()
  end

  @spec advance_time(Stopwatch.t(), Time.t()) :: Stopwatch.t()
  def advance_time(stopwatch, time) do
    if stopwatch.state == :running do
      {seconds, _} = Time.to_seconds_after_midnight(time)
      new_time = Time.add(stopwatch.current_lap, seconds)
      %{stopwatch | current_lap: new_time}
    else
      stopwatch
    end
  end

  @spec total(Stopwatch.t()) :: Time.t()
  def total(stopwatch) do
    previous_lap_seconds =
      stopwatch.previous_laps
      |> Enum.reduce(0, fn lap, acc ->
        {seconds, _microseconds} = Time.to_seconds_after_midnight(lap)
        acc + seconds
      end)

    {current_lap_seconds, _} = Time.to_seconds_after_midnight(stopwatch.current_lap)

    total_seconds = previous_lap_seconds + current_lap_seconds
    Time.from_seconds_after_midnight(total_seconds)
  end

  @spec start(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def start(%Stopwatch{state: state} = stopwatch) when state in [:ready, :stopped] do
    %{stopwatch | state: :running}
  end

  def start(_) do
    {:error, "cannot start an already running stopwatch"}
  end

  @spec stop(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def stop(%Stopwatch{state: state} = stopwatch) when state in [:running] do
    %{stopwatch | state: :stopped}
  end

  def stop(_) do
    {:error, "cannot stop a stopwatch that is not running"}
  end

  @spec lap(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def lap(%Stopwatch{state: state} = stopwatch) when state in [:running] do
    %{
      stopwatch
      | previous_laps: [stopwatch.current_lap | stopwatch.previous_laps],
        current_lap: Time.new!(0, 0, 0)
    }
  end

  def lap(_) do
    {:error, "cannot lap a stopwatch that is not running"}
  end

  @spec reset(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def reset(%Stopwatch{state: state} = stopwatch) when state in [:stopped] do
    %{stopwatch | current_lap: Time.new!(0, 0, 0), previous_laps: [], state: :ready}
  end

  def reset(_) do
    {:error, "cannot reset a stopwatch that is not stopped"}
  end
end
