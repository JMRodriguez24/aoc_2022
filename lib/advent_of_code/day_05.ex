defmodule AdventOfCode.Day05 do
  defmodule Stack do
    defstruct crates: []

    def new(crates) do
      %Stack{crates: Enum.reverse(crates)}
    end

    def take(%Stack{crates: [top | remaining]} = stack) do
      {top, %{stack | crates: remaining}}
    end

    def take_many(%Stack{crates: crates} = stack, n) do
      {top_n, remaining} = Enum.split(crates, n)
      {top_n, %{stack | crates: remaining}}
    end

    def put(%Stack{crates: crates} = stack, crate) do
      %{stack | crates: [crate | crates]}
    end

    def put_many(%Stack{crates: crates} = stack, new_crates) do
      %{stack | crates: new_crates ++ crates}
    end
  end

  defmodule Instruction do
    defstruct quantity: nil, from: nil, to: nil

    def new(quantity, from, to) do
      %__MODULE__{quantity: quantity, from: from, to: to}
    end
  end

  defp parse_stacks(input) do
    String.trim_trailing(input)
    |> String.split("\n")
    |> Enum.take_while(fn s -> String.trim(s) |> String.first() != "1" end)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.chunk_every(&1, 4, 4, Stream.cycle(' ')))
    |> Enum.map(fn chunks -> Enum.map(chunks, fn [_, v | _] -> v end) end)
    |> Enum.map(&Enum.with_index/1)
    |> List.flatten()
    |> Enum.reduce(
      Map.new(),
      fn {v, idx}, acc ->
        k = idx + 1
        Map.update(acc, k, [v], fn existing -> [v | existing] end)
      end
    )
    |> Enum.map(fn {k, v} -> {k, Enum.filter(v, &(&1 != 32))} end)
    |> Enum.map(fn {k, v} -> {k, Stack.new(v)} end)
    |> Enum.into(Map.new())
  end

  defp parse_instructions(input) do
    String.trim_trailing(input)
    |> String.split("\n")
    |> Enum.filter(fn s -> String.trim(s) |> String.starts_with?("move") end)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [_, q, _, f, _, t] ->
      {q, _} = Integer.parse(q)
      {f, _} = Integer.parse(f)
      {t, _} = Integer.parse(t)

      Instruction.new(q, f, t)
    end)
  end

  defp execute_instruction_p1(%Instruction{quantity: q, from: f, to: t} = instruction, stacks) do
    if(q == 0) do
      stacks
    else
      from_stack = Map.get(stacks, f)
      to_stack = Map.get(stacks, t)

      {top, updated_from_stack} = Stack.take(from_stack)
      updated_to_stack = Stack.put(to_stack, top)

      execute_instruction_p1(
        %{instruction | quantity: q - 1, from: f, to: t},
        %{stacks | f => updated_from_stack, t => updated_to_stack}
      )
    end
  end

  def part1(input) do
    stacks = parse_stacks(input)
    instructions = parse_instructions(input)

    updated_stacks = Enum.reduce(instructions, stacks, &execute_instruction_p1/2)

    for {_, %Stack{crates: [h | _]}} <- updated_stacks do
      h
    end
  end

  defp execute_instruction_p2(%Instruction{quantity: q, from: f, to: t}, stacks) do
    from_stack = Map.get(stacks, f)
    to_stack = Map.get(stacks, t)

    {top, updated_from_stack} = Stack.take_many(from_stack, q)
    updated_to_stacks = Stack.put_many(to_stack, top)

    %{stacks | f => updated_from_stack, t => updated_to_stacks}
  end

  def part2(input) do
    stacks = parse_stacks(input)
    instructions = parse_instructions(input)

    updated_stacks = Enum.reduce(instructions, stacks, &execute_instruction_p2/2)

    for {_, %Stack{crates: [h | _]}} <- updated_stacks do
      h
    end
  end
end
