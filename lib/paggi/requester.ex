defmodule Paggi.Requester do
  @moduledoc """

  """
  require Logger
  use HTTPoison.Base

  alias HTTPoison.Request

  defp get_url(url) do
    with {:ok, [environment: environment]} <- Application.fetch_env(:paggi, Paggi) do
      case Paggi.get_env(environment) do
        "staging" ->
          "https://api.stg.paggi.com#{url}"

        "production" ->
          "https://api.paggi.com#{url}"
      end
    end
  end

  defp get_headers(headers \\ []) do
    with {:ok, [token: token]} <- Application.fetch_env(:paggi, Paggi) do
      headers ++ [
          {"Authorization", "Bearer #{Paggi.get_env(token)}"},
          {"Accept", "application/json"},
          {"Content-Type", "application/json; charset=utf-8"},
        ]
    end
  end

  defp get_body(body), do: Poison.encode!(body)

  defp get_response({:ok, %{status_code: status_code, body: body}}, resource) do
    %Paggi.Response{
      status_code: status_code,
      body: body,
      resource: resource
    }
    |> case do
      %{body: ""} = response ->
        response
        |> Map.put(:body, %{})

      %{body: body} = response ->
        response
        |> Map.put(:body, Poison.decode!(body))
    end
  end
  defp get_response({:error, %{reason: reason}}, resource) do
    %Paggi.Response{
      status_code: 500,
      body: %{"message" => reason},
      resource: resource
    }
  end

  @doc """

  """
  def make_request(method, [resource], id \\ nil, body \\ nil, uri \\ nil) when is_atom(method) and is_binary(resource) do
    uri =
      cond do
        not is_nil(id) and not is_nil(uri) -> "/partners/#{Paggi.get_partner_id()}/#{resource}/#{id}/#{uri}"
        not is_nil(id) -> "/partners/#{Paggi.get_partner_id()}/#{resource}/#{id}"
        true -> "/partners/#{Paggi.get_partner_id()}/#{resource}"
      end

    case body do
      nil ->
        %Request{
          method: method,
          url: get_url(uri),
          headers: get_headers(),
          options: [
            timeout: 9_000_000,
            recv_timeout: 9_000_000
          ]
        }

      body ->
        %Request{
          method: method,
          url: get_url(uri),
          body: get_body(body),
          headers: get_headers(),
          options: [
            timeout: 9_000_000,
            recv_timeout: 9_000_000
          ]
        }
    end
    |> case do
      %Request{} = api_request ->
        Logger.debug("[#{__MODULE__}] Requesting to URL: #{inspect(api_request.url)}")
        Logger.debug("[#{__MODULE__}] Requesting with method: #{inspect(api_request.method)}")
        Logger.debug("[#{__MODULE__}] Requesting with headers: #{inspect(api_request.headers)}")
        Logger.debug("[#{__MODULE__}] Requesting with body: #{inspect(api_request.body)}")

        api_request
        |> request()
        |> get_response(resource)
    end
  end
end
