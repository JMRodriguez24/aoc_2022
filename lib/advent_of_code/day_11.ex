defmodule AdventOfCode.Day11 do
  defmodule Monkey do
    defstruct id: nil, items: nil, operation: nil, test: nil, divisible: nil

    def new(id, starting_items, operation, {divisible, test}) do
      %__MODULE__{
        id: id,
        items: starting_items,
        operation: operation,
        divisible: divisible,
        test: test
      }
    end
  end

  defp parse_test(
         "Test: divisible by " <> divisible,
         "If true: throw to monkey " <> truthy,
         "If false: throw to monkey " <> falsy
       ) do
    {d, _} = Integer.parse(divisible)

    {
      d,
      fn worry_level ->
        if Integer.mod(worry_level, d) == 0 do
          truthy
        else
          falsy
        end
      end
    }
  end

  defp parse_value("old", old), do: old

  defp parse_value(v, _) do
    {i, _} = Integer.parse(v)
    i
  end

  defp parse_operation("Operation: new = " <> operation) do
    [lhs, op, rhs] = String.split(operation, " ")

    fn old ->
      case op do
        "+" ->
          parse_value(lhs, old) + parse_value(rhs, old)

        "*" ->
          parse_value(lhs, old) * parse_value(rhs, old)
      end
    end
  end

  defp parse_starting_items("Starting items: " <> starting_items_str) do
    String.split(starting_items_str, ",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn s ->
      {i, _} = Integer.parse(s)
      i
    end)
  end

  defp lines_to_monkeys_helper([], monkeys), do: monkeys

  defp lines_to_monkeys_helper(
         [
           "Monkey " <> id,
           starting_items,
           operation,
           test,
           thruthy,
           falsy | rest
         ],
         monkeys
       ) do
    id = String.trim_trailing(id, ":")

    lines_to_monkeys_helper(
      rest,
      Map.put(
        monkeys,
        id,
        Monkey.new(
          id,
          parse_starting_items(starting_items),
          parse_operation(operation),
          parse_test(test, thruthy, falsy)
        )
      )
    )
  end

  defp lines_to_monkeys(lines) do
    lines_to_monkeys_helper(lines, %{})
  end

  def monkeys(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> lines_to_monkeys()
  end

  defp inspect(%Monkey{items: []}, _worry_reduction, monkeys, inspected), do: {monkeys, inspected}

  defp inspect(
         %Monkey{items: [worry_level | rest], id: id, operation: op, test: test} = m,
         worry_reduction,
         monkeys,
         inspected
       ) do
    new_inspected = Map.update(inspected, id, 1, &(&1 + 1))

    new_worry_level =
      op.(worry_level)
      |> worry_reduction.()

    dst = test.(new_worry_level)

    new_monkeys =
      Map.put(monkeys, id, %{m | items: rest})
      |> Map.update!(
        dst,
        fn %Monkey{items: items} = m ->
          %{m | items: [new_worry_level | items]}
        end
      )

    inspect(new_monkeys[id], worry_reduction, new_monkeys, new_inspected)
  end

  defp round([], _worry_reduction, monkeys, inspected), do: {monkeys, inspected}

  defp round([k | rest], worry_reduction, monkeys, inspected) do
    {new_monkeys, new_inspected} = inspect(monkeys[k], worry_reduction, monkeys, inspected)
    round(rest, worry_reduction, new_monkeys, new_inspected)
  end

  defp rounds_helper([], _worry_reduction, _monkeys, inspected), do: inspected

  defp rounds_helper([_ | rest], worry_reduction, monkeys, inspected) do
    {new_monkeys, new_inspected} = round(Map.keys(monkeys), worry_reduction, monkeys, inspected)
    rounds_helper(rest, worry_reduction, new_monkeys, new_inspected)
  end

  defp rounds(ms, n, worry_reduction) do
    Enum.into(1..n, [])
    |> rounds_helper(worry_reduction, ms, %{})
  end

  defp monkey_business(inspections) do
    Map.values(inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&*/2)
  end

  def part1(input) do
    monkeys(input)
    |> rounds(20, &div(&1, 3))
    |> monkey_business()
  end

  def part2(input) do
    monkeys = monkeys(input)

    worry_reduction_factor =
      Map.values(monkeys)
      |> Enum.map(fn %Monkey{divisible: divisible} -> divisible end)
      |> Enum.reduce(&*/2)

    monkeys
    |> rounds(10000, &Integer.mod(&1, worry_reduction_factor))
    |> monkey_business()
  end
end
