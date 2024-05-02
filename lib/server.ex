defmodule Calculator.Server do
  use GenServer

  # API
  
   def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Returns the calculator history as a list of entries in the 
  following format:
      - caller: #PID<...> of the caller;
      - timestamp: UNIX timestamp in seconds;
      - input: Map with the following values:
	 - mass: positive integer value;
	 - route: list of tuples with direction &
	 destination/gravity;
      - output: positive integer value, result from the
      execution;

  """
  def get_history() do
    GenServer.call(__MODULE__, :get_history)
  end

  
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

      iex> Calculator.Server.calculate_fuel(
      ...>   28_801,
      ...>   launch: "earth",
      ...>   land: "moon",
      ...>   launch: "moon",
      ...>   land: "earth"
      ...> )
      51_951

  """
  def calculate_fuel(mass, route) do
    GenServer.call(__MODULE__,
      {:calculate_fuel, mass, route}
    )
  end

  # Lifecycle 
  
  def init(state) do
    {:ok, state}
  end

  def handle_call({:calculate_fuel, mass, route}, from, state) do
    timestamp = System.os_time(:second)
    result = Calculator.calculate_fuel(mass, route)
    log_item = %{
      caller: from,
      timestamp: timestamp,
      input: %{
	mass: mass,
	route: route
      },
      output: result
    }
    state = [log_item | state]
    {:reply, result, state}
  end

  def handle_call(:get_history, _from, state) do
    
    {:reply, state, state}
  end
end
