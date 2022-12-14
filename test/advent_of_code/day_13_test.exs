defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  describe "in_order? list of integers" do
    test "in order" do
      input = [[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]]

      result = in_order?(input)

      assert result == true
    end

    test "out of order" do
      input = [[1, 1, 5, 1, 1], [1, 1, 3, 1, 1]]

      result = in_order?(input)

      assert result == false
    end
  end

  describe "in_order? list of lists" do
    test "mixed types in order" do
      input = [[[1], [2, 3, 4]], [[1], 4]]

      result = in_order?(input)

      assert result == true
    end

    test "mixed types out of order" do
      input = [[9], [[8, 7, 6]]]

      result = in_order?(input)

      assert result == false
    end

    test "left side ran out of items" do
      input = [[[4, 4], 4, 4], [[4, 4], 4, 4, 4]]

      result = in_order?(input)

      assert result == true

      input = [[], [3]]

      result = in_order?(input)

      assert result == true
    end

    test "right side ran out of items" do
      input = [[7, 7, 7, 7], [7, 7, 7]]

      result = in_order?(input)

      assert result == false
    end

    test "additonal test" do
      input = [[[], [[6, 8, 0, 5]]], [[3], [3, []], [[4]]]]

      result = in_order?(input)

      assert result == true
    end

    test "additonal test 2" do
      input = [
        [[9, [10]], [[], [], 5, 3, 8], []],
        [
          [[[9, 5], [1, 5, 9, 1, 8], 1]],
          [
            [5, []],
            [[4, 7, 0], [3, 10], [4, 3, 8]],
            [8, [9, 0], 7, [2, 6, 6, 7], [10, 2, 5, 4, 10]],
            4,
            5
          ],
          [10, [0, 9], 2],
          [2, [[0, 3, 2, 5, 6]], [], 0, [5]],
          [6, 3, 3, []]
        ]
      ]

      result = in_order?(input)

      assert result == true
    end
  end

  test "pair 8" do
    input = [[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]]

    result = in_order?(input)

    assert result == false
  end

  test "part1" do
    input = """
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    """

    result = part1(input)

    assert result == 13
  end

  test "part2" do
    input = """
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    """

    result = part2(input)

    assert result == 140
  end
end
