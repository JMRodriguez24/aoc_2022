defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  @input """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """
  test "parse input" do
    result = parse(@input)

    assert result == %{
             "AA" => %AdventOfCode.Day16.Valve{
               name: "AA",
               flow_rate: "0",
               neighbors: ["DD", "II", "BB"]
             },
             "BB" => %AdventOfCode.Day16.Valve{
               name: "BB",
               flow_rate: "13",
               neighbors: ["CC", "AA"]
             },
             "CC" => %AdventOfCode.Day16.Valve{
               name: "CC",
               flow_rate: "2",
               neighbors: ["DD", "BB"]
             },
             "DD" => %AdventOfCode.Day16.Valve{
               name: "DD",
               flow_rate: "20",
               neighbors: ["CC", "AA", "EE"]
             },
             "EE" => %AdventOfCode.Day16.Valve{
               name: "EE",
               flow_rate: "3",
               neighbors: ["FF", "DD"]
             },
             "FF" => %AdventOfCode.Day16.Valve{
               name: "FF",
               flow_rate: "0",
               neighbors: ["EE", "GG"]
             },
             "GG" => %AdventOfCode.Day16.Valve{
               name: "GG",
               flow_rate: "0",
               neighbors: ["FF", "HH"]
             },
             "HH" => %AdventOfCode.Day16.Valve{
               name: "HH",
               flow_rate: "22",
               neighbors: ["GG"]
             },
             "II" => %AdventOfCode.Day16.Valve{
               name: "II",
               flow_rate: "0",
               neighbors: ["AA", "JJ"]
             },
             "JJ" => %AdventOfCode.Day16.Valve{
               name: "JJ",
               flow_rate: "21",
               neighbors: ["II"]
             }
           }
  end

  test "shortest_path_length" do
    {:ok, memo} = Agent.start_link(fn -> %{} end, name: __MODULE__)
    valves = parse(@input)
    result = shortest_path_length(valves, "AA", "HH", memo)

    assert result == 5

    result = shortest_path_length(valves, "AA", "BB", memo)

    assert result == 1

    result = shortest_path_length(valves, "JJ", "HH", memo)

    assert result == 7
  end

  test "part1" do
    input = """
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    """

    result = part1(input)

    assert result == 1645
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
