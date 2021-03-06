defmodule Paggi do
  @moduledoc """
  Paggi SDK for Elixir

  To configure your application, define on your configuration file:

  ```
    config :paggi, Paggi,
      environment: "PAGGI_ENVIRONMENT",
      token: "PAGGI_TOKEN",
      version: "PAGGI_VERSION"
  ```

  Or define environment variable for `PAGGI_ENVIRONMENT`, `PAGGI_TOKEN` and `PAGGI_VERSION`

  Our documentation can be accessed by: https://developers.paggi.com/reference
  """
  alias JOSE.JWT

  @doc """
  Initializes ETS tables.
  """
  @spec init_ets() :: :ok
  def init_ets() do
    :ets.new(Paggi, [:public, :named_table, read_concurrency: true])
  end

  @doc """
  Configure token using ETS to allow multiple TOKENS
  """
  @spec configure(String.t(), String.t()) :: :ok
  def configure(environment_variable, value) do
    cond do
      environment_variable == "PAGGI_ENVIRONMENT" and value in ["production", "staging"] ->
        :ets.insert(Paggi, {environment_variable, value})

      environment_variable == "PAGGI_TOKEN" and is_binary(value) ->
        :ets.insert(Paggi, {environment_variable, value})

      environment_variable == "PAGGI_VERSION" and value in ["v1", "v2"] ->
        :ets.insert(Paggi, {environment_variable, value})
    end

    :ok
  end

  @doc """
  Retrieve environment variables from configuration file
  """
  @spec get_env(binary | {:system, binary}) :: nil | binary
  def get_env(var) when is_binary(var), do: var
  def get_env({:system, environment_variable}) when is_binary(environment_variable), do: System.get_env(environment_variable)
  def get_env({:ets, environment_variable}) when is_binary(environment_variable) do
    case :ets.lookup(Paggi, environment_variable) do
      [] ->
        nil

      [{^environment_variable, value}] ->
        value
    end
  end

  @doc """
  Retrieve partner_id from token
  """
  def get_partner_id() do
    with {:ok, [_env, {_field, token}, _version]} <- Application.fetch_env(:paggi, Paggi) do
      [%{"partner_id" => partner_id}] = JWT.peek_payload(Paggi.get_env(token)).fields["permissions"]
      partner_id
    end
  end
end
