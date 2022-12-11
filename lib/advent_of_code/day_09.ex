defmodule AdventOfCode.Day09 do
  def moves(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, " ")))
    |> Enum.flat_map(fn [direction, cnt] ->
      {cnt, _} = Integer.parse(cnt)
      for _n <- 1..cnt do
        direction
      end
    end)
  end

  def find_diagonal({h_x, h_y}, {t_x, t_y}) when h_x < t_x and h_y < t_y, do: {t_x - 1, t_y - 1}
  def find_diagonal({h_x, h_y}, {t_x, t_y}) when h_x < t_x and h_y > t_y, do: {t_x - 1, t_y + 1}
  def find_diagonal({h_x, h_y}, {t_x, t_y}) when h_x > t_x and h_y < t_y, do: {t_x + 1, t_y - 1}
  def find_diagonal({h_x, h_y}, {t_x, t_y}) when h_x > t_x and h_y > t_y, do: {t_x + 1, t_y + 1}

  defp calculate_direction({x1, y1}, {x2, y2}), do: {x2 - x1, y2 - y1}

  defp sign_of(n) do
    cond do
      n == 0 -> 0
      n < 0 -> -1
      n > 0 -> 1
    end
  end

  defp move_closer({ox, oy}, {tx, ty}) do
    {tx + sign_of(ox), ty + sign_of(oy)}
  end

  defp move_tail?({ox, oy}) do
    abs(ox) > 1 or abs(oy) > 1
  end

  def move_pair({dx, dy}, {hx, hy}, {tx, ty} = tail) do
    {nhx, nhy} = new_head = {hx + dx, hy + dy}
    offset = {nhx - tx, nhy - ty}
    new_tail = if move_tail?(offset) do
      move_closer(offset, tail)
    else
      tail
    end
    {new_head, new_tail}
  end

  defp move_rope_helper([], _delta, new_rope), do: Enum.reverse(new_rope)
  defp move_rope_helper([head, tail | rest], delta, new_rope) do
    {new_head, new_tail} = move_pair(delta, head, tail)
    move_rope_helper([tail | rest], calculate_direction(tail, new_tail), [new_head | new_rope])
  end
  defp move_rope_helper([head | rest], delta, new_rope) do
    {new_head, new_tail} = move_pair(delta, head, {0,0})
    move_rope_helper(rest, calculate_direction({0, 0}, new_tail), [new_head | new_rope])
  end

  def move_rope(rope, delta) do
    move_rope_helper(rope, delta, [])
  end

  defp direction_deltas(direction) do
    case direction do
      "R" -> {1, 0}
      "U" -> {0, 1}
      "L" -> {-1, 0}
      "D" -> {0, -1}
    end
  end

  defp visited_by_tail_helper([], _, visited), do: visited
  defp visited_by_tail_helper([direction | rest], rope, visited) do
    new_rope = move_rope(rope, direction_deltas(direction))
    visited_by_tail_helper(rest, new_rope, MapSet.put(visited, List.last(new_rope)))
  end

  def visited_by_tail(moves, knots) do
    rope = for _ <- 1..knots, do: {0,0}
    visited_by_tail_helper(moves, rope, MapSet.new([{0, 0}]))
  end

  def part1(input) do
    moves(input)
    |> visited_by_tail(2)
    |> Enum.count()
  end

  def part2(input) do
    moves(input)
    |> visited_by_tail(10)
    |> Enum.count()
  end
end
