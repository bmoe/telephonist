defmodule Telephonist.Logger do

  require Logger

  @doc false
  def notify({:processing, {_, twilio, _} = params}, _state) do
    log twilio["CallSid"], "Processing: #{inspect params}"
  end

  def notify({:call_found, call}, _state) do
    log call.sid, """
    Call found in status #{inspect call.status} and #{inspect call.state}"
    """
  end

  def notify({:call_not_found, call}, _state) do
    log call.sid, "Call not found"
  end

  def notify({:completed, call}, _state) do
    log call.sid, "Call completed"
  end

  def notify({:transition, {call, twilio, _data}}, _state) do
    log call.sid, """
    Transitioning on #{inspect call.state.name} in response to #{inspect twilio}
    """
  end

  def notify({:transition_failed,
                    {_exception, call, _twilio, _data}}, _state) do
    log call.sid, "Transition on #{inspect call.state.name} failed!"
  end

  def notify({:new_state, call}, _state) do
    log call.sid, "New state: #{inspect call.state}"
  end

  def notify(_event, _state), do: {:ok, :not_handled}

  defp log(sid, string) when sid == nil, do: log("unknown", string)
  defp log(sid, string) do
    msg = "Telephonist: [#{sid}] #{string}"
    Logger.debug msg
    {:ok, msg}
  end
end
