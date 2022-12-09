defmodule AdventOfCode.Day08 do
  defp trees(input) do
    String.trim(input)
    |> String.split("\n")
    |> trees_helper(1, %{})
  end

  defp trees_helper([], _, trees), do: trees

  defp trees_helper([line | rest], row, trees) do
    new_trees =
      1..String.length(line)
      |> Enum.map(fn column ->
        with c <- String.at(line, column - 1),
             h <- String.to_integer(c) do
          {[row, column], h}
        end
      end)
      |> Enum.reduce(%{row => %{}}, fn {path, height}, acc -> put_in(acc, path, height) end)

    trees_helper(rest, row + 1, Map.merge(trees, new_trees))
  end

  defp visible?(1, _column, _number_of_rows, _number_of_columns, _trees), do: true
  defp visible?(_row, 1, _number_of_rows, _number_of_columns, _trees), do: true

  defp visible?(row, _column, number_of_rows, _number_of_columns, _trees)
       when row == number_of_rows,
       do: true

  defp visible?(_row, column, _number_of_rows, number_of_columns, _trees)
       when column == number_of_columns,
       do: true

  defp visible?(row, column, number_of_rows, number_of_columns, trees) do
    height = get_in(trees, [row, column])

    Enum.all?(1..(column - 1), fn c -> get_in(trees, [row, c]) < height end) or
      Enum.all?(1..(row - 1), fn r -> get_in(trees, [r, column]) < height end) or
      Enum.all?((column + 1)..number_of_columns, fn c -> get_in(trees, [row, c]) < height end) or
      Enum.all?((row + 1)..number_of_rows, fn r -> get_in(trees, [r, column]) < height end)
  end

  defp find_visible_trees(trees) do
    number_of_rows = Map.keys(trees) |> length
    number_of_columns = Map.keys(trees[1]) |> length

    for row <- 1..number_of_rows,
        column <- 1..number_of_columns,
        visible?(row, column, number_of_rows, number_of_columns, trees) do
      {row, column}
    end
  end

  defp reduce_while_helper(tree_house_height, other_height, acc) do
    if tree_house_height > other_height do
      {:cont, acc + 1}
    else
      {:halt, acc + 1}
    end
  end

  defp scenic_score_helper(1, _column, _number_of_rows, _number_of_columns, _trees), do: 0
  defp scenic_score_helper(_row, 1, _number_of_rows, _number_of_columns, _trees), do: 0

  defp scenic_score_helper(row, _column, number_of_rows, _number_of_columns, _trees)
       when row == number_of_rows,
       do: 0

  defp scenic_score_helper(_row, column, _number_of_rows, number_of_columns, _trees)
       when column == number_of_columns,
       do: 0

  defp scenic_score_helper(row, column, number_of_rows, number_of_columns, trees) do
    height = get_in(trees, [row, column])

    Enum.reduce_while((column - 1)..1, 0, fn c, acc ->
      reduce_while_helper(height, get_in(trees, [row, c]), acc)
    end) *
      Enum.reduce_while((row - 1)..1, 0, fn r, acc ->
        reduce_while_helper(height, get_in(trees, [r, column]), acc)
      end) *
      Enum.reduce_while((column + 1)..number_of_columns, 0, fn c, acc ->
        reduce_while_helper(height, get_in(trees, [row, c]), acc)
      end) *
      Enum.reduce_while((row + 1)..number_of_rows, 0, fn r, acc ->
        reduce_while_helper(height, get_in(trees, [r, column]), acc)
      end)
  end

  defp scenic_score(trees) do
    number_of_rows = Map.keys(trees) |> length
    number_of_columns = Map.keys(trees[1]) |> length

    for row <- 1..number_of_rows,
        column <- 1..number_of_columns do
      scenic_score_helper(row, column, number_of_rows, number_of_columns, trees)
    end
  end

  def part1(input) do
    trees(input)
    |> find_visible_trees()
    |> Enum.count()
  end

  def part2(input) do
    trees(input)
    |> IO.inspect()
    |> scenic_score()
    |> Enum.max()
  end
end
