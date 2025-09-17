defmodule RemoteControlCar do
  # Please implement the struct with the specified fields
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new() do
    %RemoteControlCar{
      battery_percentage: 100,
      distance_driven_in_meters: 0,
      nickname: "none"
    }
  end

  def new(nickname) do
    %RemoteControlCar{
      battery_percentage: 100,
      distance_driven_in_meters: 0,
      nickname: nickname
    }
  end

  def display_distance(%RemoteControlCar{distance_driven_in_meters: meters}) do
    "#{meters} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: battery}) do
    case battery do
      0 -> "Battery empty"
      _ -> "Battery at #{battery}%"
    end
  end

  def drive(
        %RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance} = car
      ) do
    if battery > 0 do
      %{car | battery_percentage: battery - 1, distance_driven_in_meters: distance + 20}
    else
      car
    end
  end
end
