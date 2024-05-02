defmodule Calculator do
  alias Calculator.Constants.Gravity
  alias Calculator.Constants.Fuel
  alias Decimal, as: D
  require Decimal
  require Gravity
  require Fuel.Land
  require Fuel.Launch
  require Logger

  @moduledoc """
  Documentation for `Calculator`, module which does variety of
  calculations needed for NASA, currently supporting fuel
  calculations.  This is a module containing logic only, should be
  accessed through its actor `Calculator.Server`.
  """

  @rounding_strategy :down

  @doc """
  Calculate fuel consumption for given mass & route.

  ## Parameters

  - mass - Expressed as integer value in kilograms (kg).
  - route - List of tuples with direction & destination/gravity;
    - direction atom - either `:launch` or `:land`;
    - destination - bitstring;
      - One of "earth", "moon", "mars";
      - Capitalization does not matter, e.g. "Earth";
      - Atoms can be sent as well, e.g. :earth;
    - gravity - alternative to destination;
        - Should be a positive integer value;
    - Keyword list can be used for the route as well;

  ## Examples

      iex> Calculator.calculate_fuel(28_801, [{:land, "earth"}])
      13_447

      iex> Calculator.calculate_fuel(28_801, land: "Earth")
      13_447

      iex> Calculator.calculate_fuel(28_801, land: :earth)
      13_447

      iex> Calculator.calculate_fuel(28_801, [{:land, 9.807}])
      13_447

  """
  def calculate_fuel(mass, route \\ [])

  def calculate_fuel(mass, _)
      when not is_integer(mass) or mass <= 0 do
    {
      :error,
      "Invalid mass value: #{mass}.  " <>
        "Positive integer value expected."
    }
  end

  def calculate_fuel(mass, route)
      when is_list(route) and is_integer(mass) do
    route
    |> sanitize_route()
    |> validate_route()
    |> case do
      {:ok, valid_route} ->
        process_route(mass, valid_route)
        |> Kernel.-(mass)

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp process_route(mass, []), do: mass

  defp process_route(mass, [waypoint | rest])
       when is_integer(mass) and is_tuple(waypoint) do
    case process_waypoint(mass, waypoint) do
      {:ok, output} ->
        accumulated_mass = mass + output
        process_route(accumulated_mass, rest)

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp gravity(destination)
       when is_bitstring(destination) do
    case destination do
      "earth" ->
        {:ok, Gravity.earth()}

      "mars" ->
        {:ok, Gravity.mars()}

      "moon" ->
        {:ok, Gravity.moon()}

      _ ->
        {:error, "Invalid destination: #{destination}"}
    end
  end

  defp process_waypoint(mass, {direction, destination})
       when is_integer(mass) and is_atom(direction) and
              is_bitstring(destination) do
    with {:ok, gravity} <- gravity(destination) do
      process_waypoint(mass, {direction, gravity})
    else
      {:error, msg} ->
        {:error, msg}
    end
  end

  defp process_waypoint(mass, {direction, gravity})
       when is_integer(mass) and is_atom(direction) and
              is_float(gravity) do
    gravity =
      gravity
      |> Decimal.from_float()

    process_waypoint(mass, {direction, gravity})
  end

  defp process_waypoint(mass, {direction, gravity})
       when is_integer(mass) and is_atom(direction) and
              D.is_decimal(gravity) do
    case direction do
      :land ->
        landing_fuel = calculate_landing(mass, gravity)
        {:ok, landing_fuel}

      :launch ->
        launching_fuel = calculate_launching(mass, gravity)
        {:ok, launching_fuel}

      _ ->
        {
          :error,
          "Invalid direction: #{direction}."
        }
    end
  end

  defp sanitize_route(route) do
    route
    |> Enum.map(fn w -> sanitize_waypoint(w) end)
  end

  # Sanitizes waypoint tuple information.  In particular in case of
  # bitstring sent as destination it normalizes the data (downcase &
  # trim), otherwise it simply propagates the data.

  defp sanitize_waypoint({direction, destination})
       when is_atom(direction) and is_bitstring(destination) do
    sanitized_destination =
      destination
      |> String.downcase()
      |> String.trim()

    {direction, sanitized_destination}
  end

  defp sanitize_waypoint({direction, gravity})
       when is_atom(direction) and is_float(gravity) do
    {direction, gravity}
  end

  defp sanitize_waypoint({direction, destination})
       when is_atom(direction) and is_atom(destination) do
    destination =
      destination
      |> Kernel.to_string()

    {direction, destination}
  end

  # Parses & validates tuple route list.

  defp validate_route(route)
  defp validate_route([]), do: {:ok, []}

  defp validate_route([waypoint | rest]) do
    with {:ok, valid_waypoint} <- validate_waypoint(waypoint),
         {:ok, valid_route} <- validate_route(rest) do
      {:ok, [valid_waypoint | valid_route]}
    else
      {:error, msg} ->
        {:error, msg}
    end
  end

  # Parses & validates tuple waypoint information. 

  defp validate_waypoint({direction, destination} = waypoint)
       when is_atom(direction) and is_bitstring(destination) do
    cond do
      validate_direction(direction) == :error ->
        {
          :error,
          "Invalid direction in waypoint: :#{direction}."
        }

      validate_destination(destination) == :error ->
        {
          :error,
          "Invalid destination in waypoint: \"#{destination}\"."
        }

      true ->
        {:ok, waypoint}
    end
  end

  defp validate_waypoint({direction, gravity} = waypoint)
       when is_atom(direction) and is_float(gravity) do
    cond do
      validate_direction(direction) == :error ->
        {
          :error,
          "Invalid direction in waypoint: :#{direction}."
        }

      gravity < 0 ->
        {
          :error,
          "Invalid gravity value in waypoint: #{gravity}."
        }

      true ->
        {:ok, waypoint}
    end
  end

  defp validate_direction(direction)
       when is_atom(direction) do
    case direction do
      :land -> :ok
      :launch -> :ok
      _ -> :error
    end
  end

  defp validate_destination(destination)
       when is_atom(destination) do
    destination
    |> Kernel.to_string()
    |> validate_destination()
  end

  defp validate_destination(destination)
       when is_bitstring(destination) do
    case destination do
      "earth" -> :ok
      "mars" -> :ok
      "moon" -> :ok
      _ -> :error
    end
  end

  defp calculate_landing(mass, _) when mass <= 0, do: 0

  defp calculate_landing(mass, gravity)
       when is_integer(mass) and D.is_decimal(gravity) do
    fuel_mass =
      Decimal.new(mass)
      |> Decimal.mult(gravity)
      |> Decimal.mult(Fuel.Land.consumption_coefficient())
      |> Decimal.sub(Fuel.Land.surplus())
      |> Decimal.round(0, @rounding_strategy)
      |> Decimal.to_integer()

    Logger.debug(
      "landing gravity:#{gravity} " <>
        "mass:#{mass} fuel_mass:#{fuel_mass}"
    )

    cond do
      fuel_mass <= 0 ->
        0

      fuel_mass > 0 ->
        fuel_mass + calculate_landing(fuel_mass, gravity)
    end
  end

  defp calculate_launching(mass, gravity)
       when is_integer(mass) and D.is_decimal(gravity) do
    fuel_mass =
      Decimal.new(mass)
      |> Decimal.mult(gravity)
      |> Decimal.mult(Fuel.Launch.consumption_coefficient())
      |> Decimal.sub(Fuel.Launch.surplus())
      |> Decimal.round(0, @rounding_strategy)
      |> Decimal.to_integer()

    Logger.debug(
      "launching gravity:#{gravity} " <>
        "mass:#{mass} fuel_mass:#{fuel_mass}"
    )

    cond do
      fuel_mass <= 0 ->
        0

      fuel_mass > 0 ->
        fuel_mass + calculate_launching(fuel_mass, gravity)
    end
  end
end
