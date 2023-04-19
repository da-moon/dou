defmodule ConsulManager.Console do
  @behaviour :gen_event

  def init({__MODULE__, name}) do
    {:ok, configure(name, [])}
  end

  def handle_call({:configure, opts}, %{name: name}) do
    {:ok, :ok, configure(name, opts)}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_event({_level, gl, {Logger, _, _, _,}}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, %{level: min_level} = state) do
    if is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt do
      log_event(level, msg, ts, md, state)
    end

    {:ok, state}
  end

  @spec handle_info(any, any) :: {:ok, any}
  def handle_info(_mgs, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_reason, state, _extra) do
    {:ok, state}
  end

  defp configure(name, opts) do
    env = Application.get_env(:logger, name, [])
    opts = Keyword.merge(env, opts)
    Application.put_env(:logger, name, opts)

    level = Keyword.get(opts, :level)
    fields = Keyword.get(opts, :fields) || %{}
    style = Keyword.get(opts, :style) || :line
    utc_log = Application.get_env(:logger, :utc_log, false)

    formatter =
      case ConsulManager.JSON.resolve_formatter_config(Keyword.get(opts, :formatter)) do
        {:ok, fun} ->
          fun

        {:error, bad_formatter} ->
          raise "Bad formatter configured for :logger, #{name} -- #{inspect{bad_formatter}}"
      end

    %{level: level, fields: fields, utc_log: utc_log, formatter: formatter, style: style}
  end

  def log_event(level, msg, ts, md, state) do
    case ConsulManager.JSON.event(level, msg, ts, md, state) do
      {:ok, log} ->
        IO.puts(log)
      {:error, reason} ->
        IO.puts("Failed to serialize event. error: #{inspect(reason)}")
    end
  end
end
