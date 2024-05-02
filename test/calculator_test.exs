defmodule CalculatorTest do
  use ExUnit.Case, async: true
  doctest Calculator
  doctest Calculator.Server
  setup_all :disable_logger

  defp disable_logger(_context) do
    Logger.configure(level: :warning)
  end
  
  test "Apollo 11 - flying from Earth to the Moon & back" do
    output =
      Calculator.calculate_fuel(
        28_801,
        launch: "earth",
        land: "moon",
        launch: "moon",
        land: "earth"
      )

    # 53
    assert output == 51_898
  end

  test "Mission on Mars - flying from Earth to Mars & back" do
    output =
      Calculator.calculate_fuel(
        14_606,
        launch: "Earth",
        land: "Mars",
        launch: "Mars",
        land: "Earth"
      )

    # 94
    assert output == 33_388
  end

  test "Passenger ship - flying from Earth to Mars, the Moon & back" do
    output =
      Calculator.calculate_fuel(
        75_432,
        launch: "Earth",
        land: "Moon",
        launch: "Moon",
        land: "Mars",
        launch: "Mars",
        land: "Earth"
      )

    # 122
    assert output == 212_161
  end

  test "Negative input for mass" do
    expected = {
      :error,
      "Invalid mass value: -10121.  Positive integer value expected."
    }

    actual =
      Calculator.calculate_fuel(
        -10_121,
        launch: "earth",
        land: "mars"
      )

    assert actual == expected
  end

  test "Characters input for mass" do
    expected = {
      :error,
      "Invalid mass value: <invalid_mass>.  Positive integer value expected."
    }

    actual =
      Calculator.calculate_fuel(
        "<invalid_mass>",
        launch: "earth",
        land: "mars"
      )

    assert actual == expected
  end

  test "Floating point input for mass" do
    expected = {
      :error,
      "Invalid mass value: 223.306.  Positive integer value expected."
    }

    actual =
      Calculator.calculate_fuel(
        223.306,
        launch: "Earth",
        land: "Mars"
      )

    assert actual == expected
  end

  test "Passanger ship sitting in place i.e. empty route" do
    expected = 0

    actual = Calculator.calculate_fuel(75_432)

    assert actual == expected
  end

  test "Invalid input for route destination" do
    expected = {
      :error,
      "Invalid destination in waypoint: \"jupiter\"."
    }

    actual =
      Calculator.calculate_fuel(
        28801,
        launch: "earth",
        land: "jupiter"
      )

    assert actual == expected
  end
end
