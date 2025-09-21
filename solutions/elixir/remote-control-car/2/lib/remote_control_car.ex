defmodule RemoteControlCar do
  @enforce_keys [:nickname]

  @default_percentage 100
  @default_distance 0

  defstruct [
    :nickname,
    battery_percentage: @default_percentage,
    distance_driven_in_meters: @default_distance
  ]

  def new() do
    %RemoteControlCar{
      battery_percentage: @default_percentage,
      distance_driven_in_meters: @default_distance,
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
