defmodule AdventOfCode.Day15 do
  @line_regex ~r/Sensor at x=([-]*\d+), y=([-]*\d+): closest beacon is at x=([-]*\d+), y=([-]*\d+)/
  defp pair(line) do
    [_match | captures] = Regex.run(@line_regex, line)

    captures
    |> Enum.map(fn s ->
      {i, _} = Integer.parse(s)
      i
    end)
    |> (fn [x1, y1, x2, y2] ->
          {{x1, y1}, {x2, y2}}
        end).()
  end

  def pairs(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.reduce([], fn l, acc ->
      {_sensor, _beacon} = p = pair(l)
      [p | acc]
    end)
  end

  defp manhattan_distance(x1, x2, y1, y2), do: abs(x1 - x2) + abs(y1 - y2)

  def offsets(0, _cnt, acc), do: acc

  def offsets(d, cnt, acc) do
    offsets(
      d - 1,
      cnt + 1,
      List.flatten(
        for n <- -d..d, m <- -cnt..cnt do
          [{n, m}, {m, n}]
        end
      )
      |> MapSet.new()
      |> MapSet.union(acc)
    )
  end

  def closest(manhattan_distance, row, x1, y1) do
    offsets(manhattan_distance, 0, MapSet.new())
    |> Enum.reduce([], fn {x2, y2}, acc ->
      if y1 + y2 == row do
        [{x1 + x2, y1 + y2} | acc]
      else
        acc
      end
    end)
    |> MapSet.new()
  end

  defp no_beacons_helper([], _, s), do: s

  defp no_beacons_helper([{{x1, y1}, {x2, y2}} | rest], row, s) do
    d = manhattan_distance(x1, x2, y1, y2)

    no_beacons_helper(
      rest,
      row,
      MapSet.union(closest(d, row, x1, y1), s)
    )
  end

  defp no_beacons(pairs, row) do
    no_beacons_helper(pairs, row, MapSet.new())
  end

  def part1(input) do
    row = 2_000_000

    pairs = pairs(input)

    found_beacons =
      Enum.map(pairs, fn {{_, _}, {bx, by}} -> {bx, by} end)
      |> Enum.filter(fn {_bx, by} -> by == row end)
      |> MapSet.new()

    pairs
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} ->
      d = manhattan_distance(x1, x2, y1, y2)
      row > y1 - d and row < y1 + d
    end)
    |> no_beacons(row)
    |> MapSet.union(found_beacons)
    |> Enum.count(fn {_x, y} -> y == row end)
  end

  def part2(_args) do
  end
end
