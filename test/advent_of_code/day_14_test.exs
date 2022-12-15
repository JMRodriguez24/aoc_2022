defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  import AdventOfCode.Day14

  test "trace_line" do
    input = [[498, 4], [498, 6]]

    result = trace_line(input)

    assert result == %{
             {498, 4} => :rock,
             {498, 5} => :rock,
             {498, 6} => :rock
           }
  end

  test "edges" do
    input = [[498, 4], [498, 6], [496, 6]]

    result = edges(input, :infinity, 0, 0)

    assert result == {496, 498, 6}
  end

  test "scan" do
    input = """
    498,4 -> 498,6 -> 496,6
    """

    result = scan(input)

    assert result == {
             496,
             498,
             6,
             %{
               {498, 4} => :rock,
               {498, 5} => :rock,
               {498, 6} => :rock,
               {497, 6} => :rock,
               {496, 6} => :rock
             }
           }
  end

  describe "move_sand" do
    test "rest" do
      structure = %{
        {496, 6} => :rock,
        {497, 6} => :rock,
        {498, 6} => :rock
      }

      cur_pos = {497, 5}

      result = move_sand(cur_pos, structure)

      assert result == :rest
    end

    test "down" do
      structure = %{}

      cur_pos = {497, 5}

      result = move_sand(cur_pos, structure)

      assert result == {497, 6}
    end

    test "diagonal_left" do
      structure = %{
        {497, 6} => :rock
      }

      cur_pos = {497, 5}

      result = move_sand(cur_pos, structure)

      assert result == {496, 6}
    end

    test "diagonal_right" do
      structure = %{
        {497, 6} => :rock,
        {496, 6} => :rock
      }

      cur_pos = {497, 5}

      result = move_sand(cur_pos, structure)

      assert result == {498, 6}
    end
  end

  test "part1" do
    input = """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """

    result = part1(input)

    assert result == 25
  end

  test "part2" do
    input = """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """

    result = part2(input)

    assert result == 93
  end
end
