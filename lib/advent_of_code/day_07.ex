defmodule AdventOfCode.Day07 do
  defp add_directory(path, name, directories) do
    put_in(directories, Enum.reverse([name | path]), Map.new())
  end

  defp add_file(path, name, size, directories) do
    put_in(directories, Enum.reverse([name | path]), size)
  end

  defp exec_commands([], _path, directories), do: directories

  defp exec_commands(["$ cd /" | rest], _path, directories) do
    exec_commands(rest, ["/"], directories)
  end

  defp exec_commands(["$ cd .." | rest], [_top | path], directories) do
    exec_commands(rest, path, directories)
  end

  defp exec_commands(["$ cd " <> directory | rest], path, directories) do
    exec_commands(rest, [directory | path], directories)
  end

  defp exec_commands(["$ ls" <> _ | rest], path, directories) do
    exec_commands(rest, path, directories)
  end

  defp exec_commands(["dir " <> name | rest], path, directories) do
    exec_commands(rest, path, add_directory(path, name, directories))
  end

  defp exec_commands([file | rest], path, directories) do
    with [size_str, name] <- String.split(file),
         {size, _} <- Integer.parse(size_str) do
      exec_commands(rest, path, add_file(path, name, size, directories))
    end
  end

  defp directory_size(directory) do
    directory_size_helper(Map.keys(directory), directory, 0)
  end

  defp directory_size_helper([], _directory, size), do: size

  defp directory_size_helper([name | rest], directory, size) do
    case directory[name] do
      file when is_integer(file) ->
        directory_size_helper(rest, directory, size + file)

      dir ->
        directory_size_helper(rest, directory, size + directory_size(dir))
    end
  end

  defp map_directories_to_size(directories, path) do
    map_directories_to_size_helper(Map.keys(directories), directories, path, %{})
  end

  defp map_directories_to_size_helper([], _directories, _path, sizes), do: sizes

  defp map_directories_to_size_helper([name | rest], directories, path, sizes) do
    case directories[name] do
      file when is_integer(file) ->
        map_directories_to_size_helper(rest, directories, path, sizes)

      dir ->
        map_directories_to_size_helper(
          rest,
          directories,
          path,
          Map.merge(
            Map.put(sizes, [name | path], directory_size(dir)),
            map_directories_to_size(dir, [name | path])
          )
        )
    end
  end

  defp get_map_of_directories_to_size(input) do
    String.trim(input)
    |> String.split("\n")
    |> exec_commands(["/"], %{"/" => %{}})
    |> map_directories_to_size([])
  end

  def part1(input) do
    get_map_of_directories_to_size(input)
    |> Map.values()
    |> Enum.filter(&(&1 < 100_000))
    |> Enum.sum()
  end

  def part2(input) do
    mapped_directories = get_map_of_directories_to_size(input)
    total_space = 70_000_000
    total_used = mapped_directories[["/"]]
    unused_space = total_space - total_used
    space_needed = 30_000_000 - unused_space

    mapped_directories
    |> Map.values()
    |> Enum.filter(&(&1 >= space_needed))
    |> Enum.min()
  end
end
