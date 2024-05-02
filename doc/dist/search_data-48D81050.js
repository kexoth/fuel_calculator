searchData={"items":[{"type":"module","title":"Calculator","doc":"Documentation for `Calculator`, module which does variety of\ncalculations needed for NASA, currently supporting fuel\ncalculations.  This is a module containing logic only, should be\naccessed through its actor `Calculator.Server`.","ref":"Calculator.html"},{"type":"function","title":"Calculator.calculate_fuel/2","doc":"Calculate fuel consumption for given mass & route.","ref":"Calculator.html#calculate_fuel/2"},{"type":"function","title":"Parameters - Calculator.calculate_fuel/2","doc":"- mass - Expressed as integer value in kilograms (kg).\n- route - List of tuples with direction & destination/gravity;\n  - direction atom - either `:launch` or `:land`;\n  - destination - bitstring;\n    - One of \"earth\", \"moon\", \"mars\";\n    - Capitalization does not matter, e.g. \"Earth\";\n    - Atoms can be sent as well, e.g. :earth;\n  - gravity - alternative to destination;\n      - Should be a positive integer value;\n  - Keyword list can be used for the route as well;","ref":"Calculator.html#calculate_fuel/2-parameters"},{"type":"function","title":"Examples - Calculator.calculate_fuel/2","doc":"iex> Calculator.calculate_fuel(28_801, [{:land, \"earth\"}])\n    13_447\n\n    iex> Calculator.calculate_fuel(28_801, land: \"Earth\")\n    13_447\n\n    iex> Calculator.calculate_fuel(28_801, land: :earth)\n    13_447\n\n    iex> Calculator.calculate_fuel(28_801, [{:land, 9.807}])\n    13_447","ref":"Calculator.html#calculate_fuel/2-examples"},{"type":"module","title":"Calculator.Constants","doc":"Constants defines various constants used in the calculations,\nnamespaced by modules.","ref":"Calculator.Constants.html"},{"type":"module","title":"Calculator.Constants.Fuel","doc":"","ref":"Calculator.Constants.Fuel.html"},{"type":"module","title":"Calculator.Constants.Fuel.Land","doc":"","ref":"Calculator.Constants.Fuel.Land.html"},{"type":"macro","title":"Calculator.Constants.Fuel.Land.consumption_coefficient/0","doc":"","ref":"Calculator.Constants.Fuel.Land.html#consumption_coefficient/0"},{"type":"macro","title":"Calculator.Constants.Fuel.Land.surplus/0","doc":"","ref":"Calculator.Constants.Fuel.Land.html#surplus/0"},{"type":"module","title":"Calculator.Constants.Fuel.Launch","doc":"","ref":"Calculator.Constants.Fuel.Launch.html"},{"type":"macro","title":"Calculator.Constants.Fuel.Launch.consumption_coefficient/0","doc":"","ref":"Calculator.Constants.Fuel.Launch.html#consumption_coefficient/0"},{"type":"macro","title":"Calculator.Constants.Fuel.Launch.surplus/0","doc":"","ref":"Calculator.Constants.Fuel.Launch.html#surplus/0"},{"type":"module","title":"Calculator.Constants.Gravity","doc":"Gravity defines the gravity constants for each planetary-mass\nobject (PMO).","ref":"Calculator.Constants.Gravity.html"},{"type":"macro","title":"Calculator.Constants.Gravity.earth/0","doc":"","ref":"Calculator.Constants.Gravity.html#earth/0"},{"type":"macro","title":"Calculator.Constants.Gravity.mars/0","doc":"","ref":"Calculator.Constants.Gravity.html#mars/0"},{"type":"macro","title":"Calculator.Constants.Gravity.moon/0","doc":"","ref":"Calculator.Constants.Gravity.html#moon/0"},{"type":"module","title":"Calculator.Server","doc":"","ref":"Calculator.Server.html"},{"type":"function","title":"Calculator.Server.calculate_fuel/2","doc":"Calculate fuel consumption for given mass & route.","ref":"Calculator.Server.html#calculate_fuel/2"},{"type":"function","title":"Parameters - Calculator.Server.calculate_fuel/2","doc":"- mass - Expressed as integer value in kilograms (kg).\n- route - List of tuples with direction & destination/gravity;\n  - direction atom - either `:launch` or `:land`;\n  - destination - bitstring;\n    - One of \"earth\", \"moon\", \"mars\";\n    - Capitalization does not matter, e.g. \"Earth\";\n    - Atoms can be sent as well, e.g. :earth;\n  - gravity - alternative to destination;\n      - Should be a positive integer value;\n  - Keyword list can be used for the route as well;","ref":"Calculator.Server.html#calculate_fuel/2-parameters"},{"type":"function","title":"Examples - Calculator.Server.calculate_fuel/2","doc":"iex> Calculator.Server.calculate_fuel(\n    ...>   28_801,\n    ...>   launch: \"earth\",\n    ...>   land: \"moon\",\n    ...>   launch: \"moon\",\n    ...>   land: \"earth\"\n    ...> )\n    51_951","ref":"Calculator.Server.html#calculate_fuel/2-examples"},{"type":"function","title":"Calculator.Server.child_spec/1","doc":"Returns a specification to start this module under a supervisor.\n\nSee `Supervisor`.","ref":"Calculator.Server.html#child_spec/1"},{"type":"function","title":"Calculator.Server.get_history/0","doc":"Returns the calculator history as a list of entries in the \nfollowing format:\n    - caller: #PID<...> of the caller;\n    - timestamp: UNIX timestamp in seconds;\n    - input: Map with the following values:\n- mass: positive integer value;\n- route: list of tuples with direction &\ndestination/gravity;\n    - output: positive integer value, result from the\n    execution;","ref":"Calculator.Server.html#get_history/0"},{"type":"function","title":"Calculator.Server.init/1","doc":"","ref":"Calculator.Server.html#init/1"},{"type":"function","title":"Calculator.Server.start_link/1","doc":"","ref":"Calculator.Server.html#start_link/1"}],"content_type":"text/markdown","producer":{"name":"ex_doc","version":[48,46,51,50,46,49]}}