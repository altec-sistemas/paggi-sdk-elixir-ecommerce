defmodule Paggi do
  @moduledoc """
  Paggi SDK for Elixir

  To configure your application, define on your configuration file:

  ```
    config :paggi, Paggi,
      environment: "PAGGI_ENVIRONMENT",
      token: "PAGGI_TOKEN"
  ```

  Or define environment variable for `PAGGI_ENVIRONMENT` and `PAGGI_TOKEN`

  Our documentation can be accessed by: https://developers.paggi.com/reference
  """
  @doc """
  Retrieve environment variables from configuration file
  """
  @spec get_env(binary | {:system, binary}) :: nil | binary
  def get_env(var) when is_binary(var), do: var
  def get_env({:system, var}) when is_binary(var), do: System.get_env(var)
end
