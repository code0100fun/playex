defmodule Playex do
  use Application.Behaviour

  def start(type//"", args//"") do
    case :erl_ddll.load_driver("./", :playerlang_drv) do
      :ok ->
        Port.open({ :spawn, :playerlang_drv }, []) |>
          Process.register(:playerlang_drv)
      { :error, :already_loaded } -> :ok
      { :error, message } -> exit(:erl_ddll.format_error(message))
    end

    Playex.Supervisor.start_link
  end

  def play do
    Port.control(:playerlang_drv, 2, "")
  end

  def stop do
    Port.close(:playerlang_drv)
  end

end
