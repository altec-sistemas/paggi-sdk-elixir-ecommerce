defmodule Paggi.Error do
  defstruct [:code, :message]
end

defmodule Paggi.ParameterError do
  defstruct [:code, :message, :parameters]
end
