defmodule AdventOfCode.Day03 do
  defmodule Compartment do
    alias AdventOfCode.Day03.Compartment

    defstruct items: nil, chars: nil, priorities: nil, priorities_set: nil

    def new(s) do
      chars = String.to_charlist(s)
      priorities = Enum.map(chars, &AdventOfCode.Day03.chars_to_priorities/1)

      %Compartment{
        items: s,
        chars: chars,
        priorities: priorities,
        priorities_set: MapSet.new(priorities)
      }
    end
  end

  defmodule RuckSack do
    alias RuckSack

    defstruct compartment1: nil, compartment2: nil, priorities: nil, priorities_set: nil, set: nil

    def new(line) do
      chars = String.to_charlist(line)
      priorities = Enum.map(chars, &AdventOfCode.Day03.chars_to_priorities/1)

      %RuckSack{
        compartment1: Compartment.new(String.slice(line, 0, div(String.length(line), 2))),
        compartment2:
          Compartment.new(
            String.slice(line, div(String.length(line), 2), div(String.length(line), 2))
          ),
        priorities: priorities,
        priorities_set: MapSet.new(priorities),
        set: MapSet.new(chars)
      }
    end

    def compartment_duplicate(%RuckSack{compartment1: c1, compartment2: c2}) do
      MapSet.intersection(c1.priorities_set, c2.priorities_set)
    end
  end

  def part1(input) do
    String.split(input)
    |> Enum.map(&RuckSack.new/1)
    |> Enum.flat_map(&RuckSack.compartment_duplicate/1)
    |> Enum.sum()
  end

  defp get_group_badges([], acc), do: acc

  defp get_group_badges(
         [
           %RuckSack{priorities_set: s1},
           %RuckSack{priorities_set: s2},
           %RuckSack{priorities_set: s3} | tail
         ],
         acc
       ) do
    intersection = MapSet.intersection(s1, s2) |> MapSet.intersection(s3)
    acc = [Enum.at(intersection, 0) | acc]
    get_group_badges(tail, acc)
  end

  def part2(input) do
    String.split(input)
    |> Enum.map(&RuckSack.new/1)
    |> get_group_badges([])
    |> Enum.sum()
  end

  def chars_to_priorities(c) when c >= 97 and c <= 122, do: c - 96
  def chars_to_priorities(c) when c >= 65 and c <= 90, do: c - 38
end
