defmodule AdventOfCode.Day11Test do
  use ExUnit.Case
  alias AdventOfCode.Day11.Monkey

  import AdventOfCode.Day11

  @input """
  Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """

  test "monkeys" do
    monkeys = part1(@input)

    Enum.each(0..3, fn idx ->
      k = "#{idx}"
      %Monkey{id: id} = monkeys[k]
      assert id == k
    end)
  end

  test "test" do
    monkeys = monkeys(@input)

    assert monkeys["0"].test.(500) == "3"
    assert monkeys["1"].test.(20) == "0"
    assert monkeys["2"].test.(23) == "3"
    assert monkeys["3"].test.(17) == "0"
  end

  test "operation" do
    monkeys = monkeys(@input)

    assert monkeys["0"].operation.(1) == 19
    assert monkeys["1"].operation.(1) == 7
    assert monkeys["2"].operation.(2) == 4
    assert monkeys["3"].operation.(1) == 4
  end

  test "part1" do
    result = part1(@input)

    assert result == 10605
  end

  @tag timeout: :infinity
  test "part2" do
    result = part2(@input)

    assert result == 2_713_310_158
  end
end
