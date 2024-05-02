# Calculator
## About
This application aims to calculate fuel to launch from one planet of
the solar system and land on another planet of the solar system,
depending on the flight route.

The formula to calculate fuel is quite simple, but it depends on the
planet's gravity. Planets NASA is interested in are:
- Earth - `9.807 m/s²`
- Moon - `1.62 m/s²`
- Mars - `3.711 m/s²`

The formula for fuel calculations for the launch is the following:
`mass * gravity * 0.042 - 33` rounded down

The formula for fuel calculations for the landing is the following:
`mass * gravity * 0.033 - 42` rounded down

For example, for the Apollo 11 Command and Service Module, with a
weight of 28801 kg, to land it on Earth, the required amount of fuel
will be:
`28801 * 9.807 * 0.033 - 42` = `9278`

However, fuel adds weight to the ship, so it requires additional fuel
until the additional fuel is 0 or negative. Additional fuel is
calculated using the same formula from above.

Example:
`9278 fuel requires 2960 more fuel`
`2960 fuel requires 915 more fuel`
`915 fuel requires 254 more fuel`
`254 fuel requires 40 more fuel`
`40 fuel requires no more fuel`

So, to land Apollo 11 CSM on the Earth, `13447` fuel is required
`(9278 + 2960 + 915 + 254 + 40)`.

The application should receive a flight route as 2 arguments. The
first one is the flight ship mass, and the second is an list of
2 element tuples, with the first element being land or launch
directive, and the second element is the target planet gravity.

For example, for the program to launch the ship from the Earth, land
it on the Moon, and return to the Earth, input arguments will look
like this:
`28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]`

The application validates the input & will log & return an
error in case the input does not match the following criteria:
1. `mass` - Should be a positive integer value;
2. `route` - Should be a list of tuples with direction & destination or
   gravity.
   - `direction` - Atom value, either `:launch` or `:land` is
     accepted;
   - `destination` - Either `bitstring` or `atom`, should be one of
     `"earth"`, `"mars"`, `"moon"`;
   - `gravity` - If you provide the gravity value, it should be
     positive floating point value;

## TODO
- [x] Sanitize input whereas possible;
- [x] Validate input, skip calculations & emit + log error;
- [x] Unit tests & doctests;
- [x] Add Supervised named GenServer which will be the front for
      interacting with the fuel calculation module. Additionaly store
      the calculations history in its state;
- [ ] Correct the fuel calculations.  Currently our calculations
      differ with the expected ones provided in the documentation.
      Investigate further what causes the differences & correct our
      calculations.  The expected output can be found in the tests
      (`test/calculator_test.exs`), you can identify the mismatch by
      running the tests.  _FWIW does not seem as a rounding error
      since we tried `Kernel`, `Float` & `Decimal` rounding, with all
      the available rounding strategies beside rounding down, with no
      success;_ 
- [ ] Follow logic directions for flight route; 
  Currently we do not validate the logic in the directions so
  the following will be a valid case:
  `28801, [{:launch, "earth"}, {:land, "moon"}, {:land, "moon"}]`

## Up & Running

To get you up & running go inside the project & in your favorite
terminal app enter the following:

```shellsession
> mix deps.get
> iex -S mix
```

## Testing
Unit test are present for the logic.  Additionally doctests are done
for both the logic & its actor.

Tests can be run using the following line:
```shellsession
> mix test
```

## Logging
We utilise `Logger` for this, the logging level is set to `:info`, if
needed can be modified under `config/config.exs`.
For the tests the logging is set to `:warning` as part of the test
setup, can be modified if needed in the test itself.

## Documentation
Documentation is generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) & can be found at
`docs/` in both HTML & ePub.

Documentation from the code can be updated using the following line:
```shellsession
> mix docs
```


## In Action
This is a usage of our calculator & getting its history at the end:

``` shellsession
iex(3)> Calculator.Server.calculate_fuel(75_432, [{:launch, "earth"},{:land, "moon"},{:launch, "moon"},{:land, "mars"},{:launch, "mars"},{:land, "earth"}])
212283
iex(4)> Calculator.Server.calculate_fuel(14_606, launch: "Earth", land: "Mars", launch: "Mars", land: "earth")
33482
iex(5)> Calculator.Server.calculate_fuel(28801, launch: :earth, land: :moon, launch: :moon, land: :earth)
51951
iex(6)> Calculator.Server.calculate_fuel(-103, launch: :earth, land: :moon)
{:error, "Invalid mass value: -103.  Positive integer value expected."}
iex(6)> Calculator.Server.get_history
[
  %{
    caller: {#PID<0.186.0>,
     [:alias | #Reference<0.0.23811.2664124577.608763906.135928>]},
    input: %{mass: -103, route: [launch: :earth, land: :moon]},
    output: {:error,
     "Invalid mass value: -103.  Positive integer value expected."},
    timestamp: 1714668437
  },
  %{
    caller: {#PID<0.199.0>,
     [:alias | #Reference<0.0.25475.3944879264.1413283841.62117>]},
    input: %{
      mass: 28801,
      route: [launch: :earth, land: :moon, launch: :moon, land: :earth]
    },
    output: 51951,
    timestamp: 1714668099
  },
  %{
    caller: {#PID<0.199.0>,
     [:alias | #Reference<0.0.25475.3944879264.1413283841.62101>]},
    input: %{
      mass: 14606,
      route: [launch: "Earth", land: "Mars", launch: "Mars", land: "earth"]
    },
    output: 33482,
    timestamp: 1714668096
  },
  %{
    caller: {#PID<0.199.0>,
     [:alias | #Reference<0.0.25475.3944879264.1413283841.62085>]},
    input: %{
      mass: 75432,
      route: [
        launch: "earth",
        land: "moon",
        launch: "moon",
        land: "mars",
        launch: "mars",
        land: "earth"
      ]
    },
    output: 212283,
    timestamp: 1714668083
  },
  %{
    caller: {#PID<0.199.0>,
     [:alias | #Reference<0.0.25475.3944879264.1413283841.61994>]},
    input: %{
      mass: 14606,
      route: [launch: "Earth", land: "Mars", launch: "Mars", land: "earth"]
    },
    output: 33482,
    timestamp: 1714667885
  }
]
```
