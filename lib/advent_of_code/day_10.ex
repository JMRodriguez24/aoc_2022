defmodule AdventOfCode.Day10 do
  defmodule Ops do
    defstruct op: nil, cycles: []

    defp get_noop(), do: fn x -> x end
    defp get_addx(n), do: fn x -> x + n end

    def new("addx " <> arg) do
      {n, _} = Integer.parse(arg)
      %__MODULE__{
        op: :addx,
        cycles: [get_noop(), get_addx(n)]
      }
    end
    def new("noop") do
      %__MODULE__{
        op: :noop,
        cycles: [fn x -> x end]
      }
    end
  end

  def cycles(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&Ops.new/1)
    |> Enum.flat_map(fn op -> op.cycles end)
  end

  defp cycle_to_x_helper([], _cycle, _x, signal_strenghts), do: signal_strenghts
  defp cycle_to_x_helper([current | rest], cycle, x, signal_strenghts) do
    new_x = current.(x)
    cycle_to_x_helper(rest, cycle+1, new_x, Map.put(signal_strenghts, cycle, x))
  end

  defp cycle_to_x(cycles), do: cycle_to_x_helper(cycles, 1, 1, %{})

  defp calculate_signal_strenghts(cycle_to_x, cycles) do
    Enum.reduce(cycles, 0, fn c, acc ->
      c * cycle_to_x[c] + acc
    end)
  end

  def part1(input) do
    cycles(input)
    |> cycle_to_x()
    |> calculate_signal_strenghts([20, 60, 100, 140, 180, 220])
  end

  defp render_line(cycle_to_x, range) do
    Enum.reduce(range, "", fn cycle, acc ->
      pixel = Integer.mod(cycle, 40) - 1
      x = cycle_to_x[cycle]
      #IO.inspect(pixel, label: "pixel")
      #IO.inspect(cycle, label: "cycle")
      #IO.inspect(x, label: "x")
      if pixel in [x-1, x, x+1] do
        "#{acc}#"
      else
        "#{acc}."
      end
    end)
  end

  defp render(cycle_to_x) do
     """
     #{render_line(cycle_to_x, 1..40)}
     #{render_line(cycle_to_x, 41..80)}
     #{render_line(cycle_to_x, 81..120)}
     #{render_line(cycle_to_x, 121..160)}
     #{render_line(cycle_to_x, 161..200)}
     #{render_line(cycle_to_x, 201..240)}
     """
  end

  def part2(input) do
    cycles(input)
    |> cycle_to_x()
    |> render()
  end
end
