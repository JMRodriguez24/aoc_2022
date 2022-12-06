defmodule AdventOfCode.Day06 do
  defp marker_position(chars, packet_size, pos) do
    {[_ | prefix_tail] = prefix, sufix} = Enum.split(chars, packet_size)
    all_different_chars? =
      Enum.frequencies(prefix) |>
      Map.keys |>
      (&(length(&1) == packet_size)).()

    if(all_different_chars?) do
      pos
    else
      updated_chars = prefix_tail ++ sufix
      marker_position(updated_chars, packet_size, pos + 1)
    end
  end

  def part1(input) do
    marker_position(String.to_charlist(input), 4, 4)
  end

  def part2(input) do
    marker_position(String.to_charlist(input), 14, 14)
  end
end
