defmodule AdventOfCode.Day14 do
  def trace_line([[c1, r1], [c2, r2]]) when c1 == c2 do
    for r <- r1..r2, into: %{}, do: {{c1, r}, :rock}
  end

  def trace_line([[c1, r1], [c2, r2]]) when r1 == r2 do
    for c <- c1..c2, into: %{}, do: {{c, r1}, :rock}
  end

  def trace_lines([], lines), do: lines

  def trace_lines([p1, p2 | []], lines),
    do: trace_lines([], Map.merge(lines, trace_line([p1, p2])))

  def trace_lines([p1, p2 | rest], lines),
    do: trace_lines([p2 | rest], Map.merge(lines, trace_line([p1, p2])))

  def edges(pairs, le, re, be) do
    {le, re} =
      Enum.map(pairs, fn [c, _] -> c end)
      |> Enum.sort(fn c1, c2 -> c1 < c2 end)
      |> (fn sorted -> {min(hd(sorted), le), max(hd(Enum.reverse(sorted)), re)} end).()

    be =
      Enum.map(pairs, fn [_, r] -> r end)
      |> Enum.max()
      |> max(be)

    {le, re, be}
  end

  def scan(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(fn l ->
      String.trim(l)
      |> String.split(" -> ")
      |> Enum.map(fn s ->
        String.split(s, ",")
        |> Enum.map(fn s ->
          {i, _} = Integer.parse(s)
          i
        end)
      end)
    end)
    |> Enum.reduce({:infinity, 0, 0, %{}}, fn pairs, {le, re, be, m} ->
      new_m = trace_lines(pairs, m)
      {le, re, be} = edges(pairs, le, re, be)
      {le, re, be, new_m}
    end)
  end

  def move_sand({c, r}, structure)
      when is_map_key(structure, {c, r + 1}) and is_map_key(structure, {c + 1, r + 1}) and
             is_map_key(structure, {c - 1, r + 1}),
      do: :rest

  def move_sand({c, r}, structure)
      when is_map_key(structure, {c, r + 1}) and is_map_key(structure, {c - 1, r + 1}),
      do: {c + 1, r + 1}

  def move_sand({c, r}, structure)
      when is_map_key(structure, {c, r + 1}),
      do: {c - 1, r + 1}

  def move_sand({c, r}, _), do: {c, r + 1}

  defp simulate_helper(_, {c, r}, le, re, be, structure) when c < le or c > re or r > be,
    do: structure

  defp simulate_helper(s, sand, le, re, be, structure) do
    case move_sand(sand, structure) do
      :rest ->
        if s == sand do
          structure
        else
          simulate_helper(s, s, le, re, be, Map.put(structure, sand, :sand))
        end

      next ->
        simulate_helper(s, next, le, re, be, structure)
    end
  end

  def simulate({le, re, be, structure}, start) do
    simulate_helper(start, start, le, re, be, Map.put(structure, start, :sand))
  end

  def part1(input) do
    start = {500, 0}

    scan(input)
    |> simulate(start)
    |> Map.values()
    |> Enum.count(&(&1 == :sand))
  end

  def part2(input) do
    start = {500, 0}

    {_, _, _, structure} = scan(input)

    be =
      Map.keys(structure)
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    IO.inspect(be)
    input = "#{input}0,#{be + 2} -> 1000,#{be + 2}"
    {_, _, _, structure} = scan(input)

    simulate({0, :infinity, be + 2, structure}, start)
    |> Map.values()
    |> Enum.count(&(&1 == :sand))
  end
end
