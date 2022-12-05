defmodule AdventOfCode.Day04 do
  defmodule AssignmentPair do
    alias AdventOfCode.Day04.AssignmentPair
    defstruct p1: nil, p2: nil, p1_set: nil, p2_set: nil

    defp two_element_list_to_range([first, last | []]), do: first..last

    defp map_to_range(str) do
      String.split(str, "-") |>
      Enum.map(&(Integer.parse(&1))) |>
      Enum.map(fn({first, _}) -> first end) |>
      two_element_list_to_range()
    end

    defp map_to_pair([p1, p2 | []]) do
      p1_range = map_to_range(p1)
      p2_range = map_to_range(p2)

      %__MODULE__{
        p1: p1_range,
        p1_set: MapSet.new(p1_range),
        p2: p2_range,
        p2_set: MapSet.new(p2_range),
      }
    end

    def new(input) do
      String.split(input, ",") |>
      map_to_pair()
    end

    def fully_contained?(%__MODULE__{p1_set: p1_set, p2_set: p2_set}) do
      MapSet.subset?(p1_set, p2_set) || MapSet.subset?(p2_set, p1_set)
    end

    def overlap?(%__MODULE__{p1_set: p1_set, p2_set: p2_set}) do
      intersection = MapSet.intersection(p1_set, p2_set)
      MapSet.size(intersection) > 0
    end
  end

  defp get_pairs(input) do
    String.trim_trailing(input) |>
    String.split("\n") |>
    Enum.map(&AssignmentPair.new/1)
  end

  def part1(input) do
    get_pairs(input)
    Enum.count(&AssignmentPair.fully_contained?/1)
  end

  def part2(input) do
    get_pairs(input) |>
    Enum.count(&AssignmentPair.overlap?/1)
  end
end
