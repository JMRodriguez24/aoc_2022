defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1 input 1" do
    input = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    result = part1(input)

    assert result == 5
  end

  test "part1 input 2" do
    input = "nppdvjthqldpwncqszvftbrmjlhg"
    result = part1(input)

    assert result == 6
  end

  test "part1 input 3" do
    input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    result = part1(input)

    assert result == 10
  end

  test "part1 input 4" do
    input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    result = part1(input)

    assert result == 11
  end

  test "part2 input 1" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    result = part2(input)

    assert result == 19
  end

  test "part2 input 2" do
    input = "bvwbjplbgvbhsrlpgdmjqwftvncz"
    result = part2(input)

    assert result == 23
  end

  test "part2 input 3" do
    input = "nppdvjthqldpwncqszvftbrmjlhg"
    result = part2(input)

    assert result == 23
  end

  test "part2 input 4" do
    input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    result = part2(input)

    assert result == 29
  end

  test "part2 input 5" do
    input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    result = part2(input)

    assert result == 26
  end
end
