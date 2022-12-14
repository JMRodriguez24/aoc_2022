defmodule AdventOfCode.Day12 do
  defmodule Graph do
    defstruct edges: %{}, vertices: MapSet.new()

    def new(vertices, edges), do: %__MODULE__{edges: edges, vertices: vertices}

    def dijkstra(graph, start_vertex, end_vertex) do
      graph
      |> dijkstra_all(start_vertex, [end_vertex])
      |> List.first()
    end

    def dijkstra_all(
          %__MODULE__{vertices: vertices, edges: edges} = _graph,
          start_vertex,
          end_vertices
        ) do
      unvisited_vertices = MapSet.new(vertices)

      vertices_distance =
        vertices
        |> Map.new(&{&1, :infinity})
        |> Map.put(start_vertex, 0)

      vertices_distance =
        edges
        |> visit(start_vertex, unvisited_vertices, vertices_distance, fn unvisited_vertices ->
          Enum.any?(end_vertices, &MapSet.member?(unvisited_vertices, &1))
        end)

      end_vertices
      |> Enum.map(&Map.fetch!(vertices_distance, &1))
      |> Enum.map(fn
        :infinity -> :no_path
        distance -> distance
      end)
    end

    defp visit(edges, current_vertex, unvisited_vertices, vertices_distance, continue_callback) do
      current_distance = Map.fetch!(vertices_distance, current_vertex)
      unvisited_vertices = MapSet.delete(unvisited_vertices, current_vertex)

      vertices_distance =
        edges
        |> Map.get(current_vertex, [])
        |> Enum.filter(&MapSet.member?(unvisited_vertices, &1))
        |> Enum.reduce(vertices_distance, fn target_vertex, vertices_distance ->
          new_distance = current_distance + 1

          Map.update!(vertices_distance, target_vertex, fn
            :infinity -> new_distance
            distance when distance > new_distance -> new_distance
            distance -> distance
          end)
        end)

      if continue_callback.(unvisited_vertices) do
        vertices_distance
        |> Enum.reject(&match?({_index, :infinity}, &1))
        |> Enum.sort_by(&elem(&1, 1))
        |> Enum.map(&elem(&1, 0))
        |> Enum.filter(&MapSet.member?(unvisited_vertices, &1))
        |> case do
          [] ->
            vertices_distance

          [next_vertex | _others] ->
            visit(edges, next_vertex, unvisited_vertices, vertices_distance, continue_callback)
        end
      else
        vertices_distance
      end
    end
  end

  defp heightmap(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil, nil}, fn {line, row_index}, {acc, start_position, end_position} ->
      line =
        line
        |> String.trim()
        |> String.to_charlist()

      heightmap =
        line
        |> Enum.with_index()
        |> Enum.map(fn
          {?S, column_index} -> {{row_index, column_index}, 0}
          {?E, column_index} -> {{row_index, column_index}, 25}
          {letter, column_index} -> {{row_index, column_index}, letter - ?a}
        end)

      start_position =
        case Enum.find_index(line, &(&1 == ?S)) do
          nil -> start_position
          column_index -> {row_index, column_index}
        end

      end_position =
        case Enum.find_index(line, &(&1 == ?E)) do
          nil -> end_position
          column_index -> {row_index, column_index}
        end

      {Map.merge(acc, Map.new(heightmap)), start_position, end_position}
    end)
  end

  defp create_graph(heightmap) do
    heightmap
    |> Map.keys()
    |> Graph.new(
      for {{row_index, column_index} = start_index, start_height} <- heightmap,
          search_index <- [
            {row_index, column_index - 1},
            {row_index, column_index + 1},
            {row_index - 1, column_index},
            {row_index + 1, column_index}
          ],
          Map.has_key?(heightmap, search_index),
          search_height = Map.fetch!(heightmap, search_index),
          search_height <= start_height + 1,
          reduce: %{} do
        acc -> Map.update(acc, search_index, [start_index], &[start_index | &1])
      end
    )
  end

  def part1(input) do
    {heightmap, start_position, end_position} = heightmap(input)

    heightmap
    |> create_graph()
    |> Graph.dijkstra(start_position, end_position)
  end

  def part2(input) do
    {heightmap, _start_position, end_position} = heightmap(input)

    possible_start_positions =
      heightmap
      |> Enum.filter(&match?({_index, 0}, &1))
      |> Enum.map(&elem(&1, 0))
      |> IO.inspect()

    heightmap
    |> create_graph()
    |> Graph.dijkstra_all(end_position, possible_start_positions)
    |> Enum.reject(&(&1 == :no_path))
    |> Enum.min()
  end
end
