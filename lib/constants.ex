defmodule Calculator.Constants do
  @moduledoc """
  Constants defines various constants used in the calculations,
  namespaced by modules.
  """
  defmodule Gravity do
    @moduledoc """
    Gravity defines the gravity constants for each planetary-mass
    object (PMO).
    """
    defmacro earth do
      quote do: Decimal.from_float(9.807)
    end

    defmacro moon do
      quote do: Decimal.from_float(1.62)
    end

    defmacro mars do
      quote do: Decimal.from_float(3.711)
    end
  end

  defmodule Fuel do
    defmodule Launch do
      defmacro consumption_coefficient do
        quote do: Decimal.from_float(0.042)
      end

      defmacro surplus do
        quote do: Decimal.new(33)
      end
    end

    defmodule Land do
      defmacro consumption_coefficient do
        quote do: Decimal.from_float(0.033)
      end

      defmacro surplus do
        quote do: Decimal.new(42)
      end
    end
  end
end
