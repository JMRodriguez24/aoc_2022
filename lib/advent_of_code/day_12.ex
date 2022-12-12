defmodule AdventOfCode.Day12 do
  defp heightmap(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.with_index(fn line, i -> {i, String.to_charlist(line)} end)
    |> Enum.into(%{})
    |> Enum.map(fn {k, v} ->
      new_v =
        Enum.with_index(v, fn pos, i -> {i, pos} end)
        |> Enum.into(%{})

      {k, new_v}
    end)
    |> Enum.into(%{})
  end

  def part1(input) do
    heightmap(input)
  end

  def part2(_args) do
  end
end
