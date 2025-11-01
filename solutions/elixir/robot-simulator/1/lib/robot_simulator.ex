defmodule RobotSimulator do
  defstruct direction: :north, x: 0, y: 0

  @type robot() :: any()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @directions [:north, :east, :south, :west]
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _) when direction not in @directions do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_integer(x) and is_integer(y) do
    %RobotSimulator{direction: direction, x: x, y: y}
  end

  def create(_, _), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    with {:ok, steps} <- parse_instructions(instructions) do
      Enum.reduce(steps, robot, &simulate_step/2)
    end
  end

  defp parse_instructions(instructions) do
    steps = String.split(instructions, "", trim: true)
    steps |> all_valid?() |> get_result(steps)
  end

  defp all_valid?(steps), do: Enum.all?(steps, fn step -> step in ["R", "L", "A"] end)

  defp get_result(true, steps), do: {:ok, steps}
  defp get_result(false, _), do: {:error, "invalid instruction"}

  defp simulate_step("A", %RobotSimulator{} = robot), do: move(robot)
  defp simulate_step("L", %RobotSimulator{} = robot), do: turn_left(robot)
  defp simulate_step("R", %RobotSimulator{} = robot), do: turn_right(robot)

  defp move(%RobotSimulator{direction: :north, y: y} = robot), do: %{robot | y: y + 1}
  defp move(%RobotSimulator{direction: :east, x: x} = robot), do: %{robot | x: x + 1}
  defp move(%RobotSimulator{direction: :south, y: y} = robot), do: %{robot | y: y - 1}
  defp move(%RobotSimulator{direction: :west, x: x} = robot), do: %{robot | x: x - 1}

  defp turn_left(%RobotSimulator{direction: :north} = robot), do: %{robot | direction: :west}
  defp turn_left(%RobotSimulator{direction: :west} = robot), do: %{robot | direction: :south}
  defp turn_left(%RobotSimulator{direction: :south} = robot), do: %{robot | direction: :east}
  defp turn_left(%RobotSimulator{direction: :east} = robot), do: %{robot | direction: :north}

  defp turn_right(%RobotSimulator{direction: :north} = robot), do: %{robot | direction: :east}
  defp turn_right(%RobotSimulator{direction: :east} = robot), do: %{robot | direction: :south}
  defp turn_right(%RobotSimulator{direction: :south} = robot), do: %{robot | direction: :west}
  defp turn_right(%RobotSimulator{direction: :west} = robot), do: %{robot | direction: :north}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(%RobotSimulator{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(%RobotSimulator{x: x, y: y}) do
    {x, y}
  end
end
