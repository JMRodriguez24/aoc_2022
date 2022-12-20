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

  def closest_in_row(d, row, x1, y1) when row < y1 + d and row > y1 - d do
    inset = abs(y1 - row)

    for x <- (-d + inset)..(d - inset), into: MapSet.new() do
      {x1 + x, row}
    end
  end

  def closest_in_row(_, _, _, _), do: MapSet.new()

  defp no_beacons_helper([], _, s), do: s

  defp no_beacons_helper([{{x1, y1}, {x2, y2}} | rest], row, s) do
    d = manhattan_distance(x1, x2, y1, y2)

    no_beacons_helper(
      rest,
      row,
      MapSet.union(closest_in_row(d, row, x1, y1), s)
    )
  end

  defp no_beacons(pairs, row) do
    no_beacons_helper(pairs, row, MapSet.new())
  end

  defp beacons_helper([], _row, s), do: s

  defp beacons_helper([{_, {x2, y2}} | rest], row, s) do
    new_s =
      if y2 == row do
        MapSet.put(s, {x2, y2})
      else
        s
      end

    beacons_helper(rest, row, new_s)
  end

  defp beacons(pairs, row) do
    beacons_helper(pairs, row, MapSet.new())
  end

  def part1(input, row) do
    pairs = pairs(input)

    pairs
    |> no_beacons(row)
    |> IO.inspect()
    |> MapSet.difference(beacons(pairs, row))
    |> Enum.count()
  end

  def ranges_for_column([], _, _, acc), do: acc

  def ranges_for_column([{_, sensor_y, d} | rest], search_space, row, acc)
      when sensor_y + d < row or sensor_y - d > row,
      do: ranges_for_column(rest, search_space, row, acc)

  def ranges_for_column([{sensor_x, sensor_y, d} | rest], search_space, row, acc) do
    inset = abs(sensor_y - row)
    sensor_min = max(sensor_x - d + inset, 0)
    sensor_max = min(sensor_x + d - inset, search_space)
    ranges_for_column(rest, search_space, row, MapSet.put(acc, sensor_min..sensor_max))
  end

  def merge_ranges([r1 | []], []), do: [r1]
  def merge_ranges([r2 | []], [r1 | []]), do: [r1, r2]

  def merge_ranges(
        [%Range{first: s1, last: e1} = r1, %Range{first: s2, last: e2} = r2 | rest],
        acc
      ) do
    if e1 + 1 >= s2 do
      new_range = s1..max(e1, e2)
      merge_ranges([new_range | rest], acc)
    else
      merge_ranges([r2 | rest], [r1 | acc])
    end
  end

  def beacon_position([_ | []], _), do: nil

  def beacon_position([%Range{first: 0, last: e1}, %Range{last: e2} | []], search_space)
      when e2 == search_space,
      do: e1 + 1

  def beacon_position([%Range{first: s1}, %Range{last: e2} | []], search_space)
      when e2 == search_space,
      do: s1 - 1

  def beacon_position([%Range{first: 0}, %Range{last: l1} | []], _),
    do: l1 + 1

  @spec distress_beacons_helper([{any, number, number}], any, number) :: no_return
  def distress_beacons_helper(sensors, search_space, row) do
    ranges =
      ranges_for_column(sensors, search_space, row, MapSet.new())
      |> Enum.sort()
      |> merge_ranges([])

    x = beacon_position(ranges, search_space)
    if x == nil, do: distress_beacons_helper(sensors, search_space, row + 1), else: {x, row}
  end

  def distress_beacon(pairs, search_space, row) do
    pairs
    |> Enum.map(fn {{x1, y1}, {x2, y2}} ->
      d = manhattan_distance(x1, x2, y1, y2)
      {x1, y1, d}
    end)
    |> distress_beacons_helper(search_space, row)
  end

  def part2(input, search_space) do
    pairs(input)
    |> distress_beacon(search_space, 0)
    |> then(fn {x, y} -> x * 4_000_000 + y end)
  end
end
