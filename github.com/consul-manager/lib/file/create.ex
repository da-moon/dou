defmodule F do
  @newline "\n"
  @ans :add_newlines

  defp concat(file, path), do: write(file, File.stream!(path), [:append])

  defp write(file, data, opts) do
    Stream.into(data, File.stream!(file, opts)) |> Stream.run()
  end
  defp write(file, data, opts, @ans) do
    write(file, Enum.map(data, &("#{&1}#{@newline}")), opts)
  end

  def write_file(file, data), do: write(file, data, [])
  def write_file(file, data, opts) do
    case Enum.find_index(opts, &(&1 == @ans)) do
      nil -> 
        write(file, data, opts)
      _ ->
        write(file, data, List.delete(opts, @ans), @ans)
    end
  end

  def write_file_and_concat(file, data, opts \\ [], path) do
    write_file(file, data, opts)
    concat(file, path)
  end
end
