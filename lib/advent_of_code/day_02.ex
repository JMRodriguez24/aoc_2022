defmodule AdventOfCode.Day02 do
  defp parse(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1))
  end

  @doc """
  The first column is what your opponent is going to play:
  A for Rock, B for Paper, and C for Scissors

  The second column, you reason, must be what you should play in response:
  X for Rock, Y for Paper, and Z for Scissors.

  The score for a single round is the score for the shape you selected
  (1 for Rock, 2 for Paper, and 3 for Scissors)
  plus the score for the outcome of the round
  (0 if you lost, 3 if the round was a draw, and 6 if you won)
  """
  def part1(input) do
    parse(input)
    |> Enum.map(&round_to_score_v1/1)
    |> Enum.sum()
  end

  defp round_to_score_v1(["B", "X"]), do: 1 + 0
  defp round_to_score_v1(["C", "Y"]), do: 2 + 0
  defp round_to_score_v1(["A", "Z"]), do: 3 + 0
  defp round_to_score_v1(["A", "X"]), do: 1 + 3
  defp round_to_score_v1(["B", "Y"]), do: 2 + 3
  defp round_to_score_v1(["C", "Z"]), do: 3 + 3
  defp round_to_score_v1(["C", "X"]), do: 1 + 6
  defp round_to_score_v1(["A", "Y"]), do: 2 + 6
  defp round_to_score_v1(["B", "Z"]), do: 3 + 6

  @doc """
  The first column is what your opponent is going to play:
  A for Rock, B for Paper, and C for Scissors

  The second column says how the round needs to end:
  X means you need to lose, Y means you need to end the round in a draw,
  and Z means you need to win.

  The score for a single round is the score for the shape you selected
  (1 for Rock, 2 for Paper, and 3 for Scissors)
  plus the score for the outcome of the round
  (0 if you lost, 3 if the round was a draw, and 6 if you won)
  """
  def part2(input) do
    parse(input)
    |> Enum.map(&round_to_score_v2/1)
    |> Enum.sum()
  end

  defp round_to_score_v2(["A", "X"]), do: 3 + 0
  defp round_to_score_v2(["B", "X"]), do: 1 + 0
  defp round_to_score_v2(["C", "X"]), do: 2 + 0
  defp round_to_score_v2(["A", "Y"]), do: 1 + 3
  defp round_to_score_v2(["B", "Y"]), do: 2 + 3
  defp round_to_score_v2(["C", "Y"]), do: 3 + 3
  defp round_to_score_v2(["A", "Z"]), do: 2 + 6
  defp round_to_score_v2(["B", "Z"]), do: 3 + 6
  defp round_to_score_v2(["C", "Z"]), do: 1 + 6
end
