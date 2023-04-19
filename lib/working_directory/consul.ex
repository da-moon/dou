defmodule WD do
  def get_consul_config, do: cwd_consul() <> "/consul.hcl"
  def get_consul_config_template, do: cwd_consul() <> "/consul.hcl.tmpl"
  def get_consul_config_dir, do: cwd_consul()
  def get_consul_log, do: cwd_consul() <> "/log/consul.log"

  defp cwd_consul, do: cwd() <> "/consul_config"

  defp cwd() do
    case File.cwd do
      {:ok, cwd} -> cwd
      {:error, _} -> "/tmp"
    end
  end
end
