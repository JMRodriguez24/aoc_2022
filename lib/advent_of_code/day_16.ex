defmodule AdventOfCode.Day16 do
  defmodule Valve do
    defstruct name: nil, flow_rate: 0, neighbors: nil

    def new(name, flow_rate, neighbors) do
      %Valve{
        name: name,
        flow_rate: flow_rate,
        neighbors: neighbors
      }
    end
  end

  @line_regex ~r/Valve ([A-Z][A-Z]) has flow rate=(\d+); tunnel[s]? lead[s]? to valve[s]? (.+)/
  def parse(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(fn line ->
      [_match | [name, flow_rate_str, valves_str]] = Regex.run(@line_regex, line)
      {flow_rate, _} = Integer.parse(flow_rate_str)
      neighbors = String.split(valves_str, ",") |> Enum.map(&String.trim/1)
      {name, Valve.new(name, flow_rate, neighbors)}
    end)
    |> Enum.into(%{})
  end

  defp should_open_valve?({_k, %{flow_rate: flow_rate}}) when flow_rate > 0, do: true
  defp should_open_valve?(_), do: false

  defp calculate_max_pressure(_, _, _, [], pressure_released), do: pressure_released

  defp calculate_max_pressure(valves, open_valves, time_limit, [valve | rest], pressure_released) do
    minute_opened = open_valves[valve]
    minutes_opened = max(time_limit - minute_opened, 0)
    pressure_released = pressure_released + valves[valve].flow_rate * minutes_opened
    calculate_max_pressure(valves, open_valves, time_limit, rest, pressure_released)
  end

  defp shortest_path_length_helper(_, start_valve, end_valve, _, _, memo)
       when start_valve == end_valve do
    Agent.update(memo, &Map.put(&1, {start_valve, end_valve}, 0))
  end

  defp shortest_path_length_helper(_, start_valve, end_valve, [n | _] = path, _, memo)
       when n == end_valve do
    l = length(path) - 1
    Agent.update(memo, &Map.put(&1, {start_valve, end_valve}, l))
    l
  end

  defp shortest_path_length_helper(
         valves,
         start_valve,
         end_valve,
         [current | _] = path,
         visited,
         memo
       ) do
    cached_value = Agent.get(memo, &Map.get(&1, {start_valve, end_valve}))

    cond do
      cached_value != nil ->
        cached_value

      MapSet.member?(visited, current) ->
        nil

      true ->
        neighbors = valves[current].neighbors

        Enum.map(neighbors, fn n ->
          shortest_path_length_helper(
            valves,
            start_valve,
            end_valve,
            [n | path],
            MapSet.put(visited, current),
            memo
          )
        end)
        |> Enum.min()
    end
  end

  def shortest_path_length(valves, current_valve, next_valve, memo) do
    shortest_path_length_helper(
      valves,
      current_valve,
      next_valve,
      [current_valve],
      MapSet.new(),
      memo
    )
  end

  defp open_valves_helper(
         valves,
         valves_to_open,
         time_limit,
         _,
         path,
         open_valves,
         _
       )
       when length(valves_to_open) == length(path) - 1 do
    IO.puts("all open")
    IO.inspect(path)
  end

  defp open_valves_helper(valves, _, time_limit, minutes_elapsed, path, open_valves, _)
       when minutes_elapsed >= time_limit do
    p = calculate_max_pressure(valves, open_valves, time_limit, Map.keys(open_valves), 0)
    IO.puts("#{inspect(path)} #{p}")
    p
  end

  defp open_valves_helper(
         valves,
         valves_to_open,
         time_limit,
         minutes_elapsed,
         [current_valve | _] = path,
         open_valves,
         memo
       ) do
    Enum.filter(valves_to_open, fn valve_to_open ->
      not Map.has_key?(open_valves, valve_to_open)
    end)
    |> Enum.reduce(0, fn valve_to_open, acc ->
      travel_time = shortest_path_length(valves, current_valve, valve_to_open, memo)
      time_to_open_valve = 1
      new_minutes_elapsed = minutes_elapsed + travel_time + time_to_open_valve

      max(
        open_valves_helper(
          valves,
          valves_to_open,
          time_limit,
          new_minutes_elapsed,
          [valve_to_open | path],
          Map.put(open_valves, valve_to_open, new_minutes_elapsed),
          memo
        ),
        acc
      )
    end)
  end

  defp open_valves(valves, valves_to_open, start, time_limit, memo) do
    open_valves_helper(valves, valves_to_open, time_limit, 0, [start], %{}, memo)
  end

  defp print_helper(
         valves,
         current,
         flags,
         visited,
         is_last,
         depth
       ) do
    %Valve{name: name, flow_rate: flow_rate, neighbors: neighbors} = Map.get(valves, current)

    if MapSet.member?(visited, current) do
      nil
    else
      cond do
        depth == 0 ->
          IO.puts("(#{name}|#{flow_rate})")

        true ->
          Enum.each(1..depth, fn d ->
            if not MapSet.member?(flags, d) do
              IO.write("    ")
            else
              IO.write("|    ")
            end
          end)

          if is_last do
            IO.puts("+--- (#{name}|#{flow_rate})")
            MapSet.put(flags, depth)
          else
            IO.puts("+--- (#{name}|#{flow_rate})")
          end
      end

      new_visited = MapSet.put(visited, current)

      Enum.with_index(neighbors)
      |> Enum.each(fn {n, i} ->
        print_helper(valves, n, flags, new_visited, length(neighbors) - 1 == i, depth + 1)
      end)
    end
  end

  def print(tree) do
    print_helper(tree, "AA", MapSet.new(), MapSet.new(), false, 0)
  end

  def part1(input) do
    {:ok, memo} = Agent.start_link(fn -> %{} end, name: __MODULE__)

    valves = parse(input)

    valves_to_open =
      Enum.filter(valves, &should_open_valve?/1)
      |> Enum.map(fn {k, _} -> k end)

    open_valves(valves, valves_to_open, "AA", 30, memo)
  end

  def part2(_args) do
  end
end
