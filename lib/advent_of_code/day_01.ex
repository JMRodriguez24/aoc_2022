defmodule AdventOfCode.Day01 do
  defp elfs(input) do
    String.split(input, "\n")
    |> Enum.chunk_by(&(&1 != ""))
    |> Enum.filter(&(&1 != [""]))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Enum.map(&Enum.sum(&1))
  end

  def part1(input) do
    elfs(input)
    |> Enum.max()
  end

  def part2(input) do
    elfs(input)
    |> Enum.sort_by(& &1, :desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
