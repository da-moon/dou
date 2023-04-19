defmodule ConsulManager.JSON do
  def event(level, msg, ts, md, %{fields: fields, utc_log: utc_log, formatter: formatter, style: style}) do
    event_formatter(level, msg, ts, md, %{fields: fields, utc_log: utc_log, formatter: formatter, style: style})
  end

  def event_formatter(level, msg, ts, md, %{fields: fields, utc_log: utc_log, formatter: formatter, style: :json}) do
    fields
    |> format_fields(md, %{
      "@timestamp": timestamp(ts, utc_log),
      level: level,
      message: to_string(msg),
      module: md[:module],
      function: md[:function],
      line: md[:line]
    })
    |> formatter.()
    |> json()
  end

  def event_formatter(level, msg, ts, md, %{fields: _fields, utc_log: utc_log, formatter: _formatter, style: :line}) do
    log =
      format_timestamp(ts, utc_log) <> " " <>
      format_function(md) <> " " <>
      format_level(level) <> " " <>
      format_message(level, msg)
    {:ok, log}
  end
  def json(event) do
    event |> pre_encode() |> Poison.encode()
  end

  defp format_timestamp(ts, utc_log) do
    Color.ok("#{timestamp(ts, utc_log)}")
  end

  defp format_function(metadata) do
    Color.marked("#{to_string(metadata[:function])}:#{to_string(metadata[:line])}")
  end

  defp format_level(level) do
    Color.info(to_string(level))
  end

  defp format_message(level, message) do
    case level do
      :debug ->
        Color.ok(to_string(message))
      :info ->
        Color.info(to_string(message))
      :warn ->
        Color.warning(to_string(message))
      :error ->
        Color.error(to_string(message))
      _ ->
        message
      end
  end


  def format_fields(fields, metadata, field_overrides) do
    metadata
    |> format_metadata()
    |> Map.merge(fields)
    |> Map.merge(field_overrides)
  end

  defp format_metadata(metadata) do
    metadata
    |> Enum.into(%{})
  end

  def resolve_formatter_config(formatter_spec, default_formatter \\ & &1) do
    case formatter_spec do
      {module, function} ->
        if Keyword.has_key?(module.__info__(:functions), function) do
          {:ok, &apply(module, function, [&1])}
        else
          {:error, {module, function}}
        end
      fun when is_function(fun) ->
        {:ok, fun}
      nil ->
        {:ok, default_formatter}
      bad_formatter ->
        {:error, bad_formatter}
    end
  end

  defp timestamp(ts, utc_log) do
    datetime(ts) <> timezone(utc_log)
  end

  defp datetime({{year, month, day}, {hour, min, sec, millis}}) do
    {:ok, ndt} = NaiveDateTime.new(year, month, day, hour, min, sec, {millis * 1000, 3})
    NaiveDateTime.to_iso8601(ndt)
  end

  defp timezone(true), do: "+00:00"
  defp timezone(_), do: timezone()

  defp timezone() do
    offset = timezone_offset()
    minute = offset |> abs() |> rem(3600) |> div(60)
    hour = offset |> abs() |> div(3600)
    sign(offset) <> zero_pad(hour, 2) <> ":" <> zero_pad(minute, 2)
  end

  defp timezone_offset() do
    t_utc = :calendar.universal_time()
    t_local = :calendar.universal_time_to_local_time(t_utc)

    s_utc = :calendar.datetime_to_gregorian_seconds(t_utc)
    s_local = :calendar.datetime_to_gregorian_seconds(t_local)

    s_local - s_utc
  end

  defp sign(total) when total < 0, do: "-"
  defp sign(_), do: "+"

  defp zero_pad(val, count) do
    num = Integer.to_string(val)
    :binary.copy("0", count - byte_size(num)) <> num
  end

  defp pre_encode(it) when is_pid(it), do: inspect(it)
  defp pre_encode(it) when is_list(it), do: Enum.map(it, &pre_encode/1)
  defp pre_encode(it) when is_tuple(it), do: pre_encode(Tuple.to_list(it))

  defp pre_encode(%module{} = it) do
    try do
      :ok = Protocol.assert_impl!(Poison.Encoder, module)
      it
    rescue
      ArgumentError -> pre_encode(Map.from_struct(it))
    end
  end

  defp pre_encode(it) when is_map(it),
    do: Enum.into(it, %{}, fn {k, v} -> {pre_encode(k), pre_encode(v)} end)

  defp pre_encode(it) when is_binary(it) do
    it
    |> String.valid?()
    |> case do
      true  -> it
      false -> inspect(it)
    end
  end

  defp pre_encode(it), do: it
end
