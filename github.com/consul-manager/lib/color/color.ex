defmodule Color do
  def default(text), do: no_color(text)
  def error(text), do: red(text)
  def marked(text), do: blue(text)
  def ok(text), do: green(text)
  def warning(text), do: yellow(text)
  def info(text), do: cyan(text)

  defp no_color(text) do
    text
  end
  defp green(text) do
    IO.ANSI.green() <> text <> IO.ANSI.reset()
  end
  defp red(text) do
    IO.ANSI.red() <> text <> IO.ANSI.reset()
  end
  defp yellow(text) do
    IO.ANSI.yellow() <> text <> IO.ANSI.reset()
  end
  defp blue(text) do
    IO.ANSI.blue() <> text <> IO.ANSI.reset()
  end
  defp cyan(text) do
    IO.ANSI.cyan() <> text <> IO.ANSI.reset()
  end
end
