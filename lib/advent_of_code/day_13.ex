defmodule AdventOfCode.Day13 do
  def eval_line(line) do
    {term, _} = Code.eval_string(line)
    term
  end

  def in_order?([[p1h | p1t], [p2h | p2t]]) when is_integer(p1h) and is_integer(p2h) do
    if p1h == p2h do
      in_order?([p1t, p2t])
    else
      p1h < p2h
    end
  end

  def in_order?([[], []]), do: true
  def in_order?([[[] | p1t], [[] | p2t]]), do: in_order?([p1t, p2t])
  def in_order?([[], p2]) when is_list(p2), do: true
  def in_order?([p1, []]) when is_list(p1), do: false

  def in_order?([[p1h | _], [p2h | _]]) when is_list(p1h) and is_list(p2h) do
    in_order?([p1h, p2h])
  end

  def in_order?([[p1h | _] = p1, [p2h | p2t]]) when is_list(p1h) and is_integer(p2h) do
    in_order?([p1, [[p2h] | p2t]])
  end

  def in_order?([[p1h | p1t], [p2h | _] = p2]) when is_list(p2h) and is_integer(p1h) do
    in_order?([[[p1h] | p1t], p2])
  end

  def part1(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.reject(&match?("", &1))
    |> Enum.map(&eval_line/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {p, _} -> in_order?(p) end)
    |> Enum.reduce(0, fn {_, i}, acc -> acc + i end)
  end

  defp add_dividers(packets) do
    [[[2]], [[6]] | packets]
  end

  defp is_divider?(packet) do
    packet in [[[2]], [[6]]]
  end

  def part2(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.reject(&match?("", &1))
    |> Enum.map(&eval_line/1)
    |> add_dividers()
    |> Enum.sort(&in_order?([&1, &2]))
    |> Enum.with_index(1)
    |> Enum.filter(&is_divider?(elem(&1, 0)))
    |> IO.inspect()
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&*/2)
  end
end
