defmodule Paggi.Requester do
  @moduledoc """

  """
  require Logger
  use HTTPoison.Base

  alias HTTPoison.Request

  defp get_url(url) do
    with {:ok, [{_field, environment}, _token, {_version, version}]} <- Application.fetch_env(:paggi, Paggi) do
      case Paggi.get_env(environment) do
        "staging" ->
          "https://api.stg.paggi.com/#{Paggi.get_env(version)}#{url}"

        "production" ->
          "https://api.paggi.com/#{Paggi.get_env(version)}#{url}"
      end
    end
  end

  defp get_headers(headers \\ []) do
    with {:ok, [_env, {_field, token}, _version]} <- Application.fetch_env(:paggi, Paggi) do
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
        Logger.debug("[#{__MODULE__}] Response with body: #{inspect(body)}")

        case Poison.decode(body) do
          {:ok, body} ->
            response
            |> Map.put(:body, body)

          _ ->
            response
          |> Map.put(:body, %{"message" => body})
        end
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
        resource == "banks" and not is_nil(id) -> "/#{resource}/#{id}"
        resource == "banks" and is_nil(id) -> "/#{resource}"
        not is_nil(id) and not is_nil(uri) -> "/partners/#{Paggi.get_partner_id()}/#{resource}/#{id}#{uri}"
        not is_nil(id) -> "/partners/#{Paggi.get_partner_id()}/#{resource}/#{id}"
        true -> "/partners/#{Paggi.get_partner_id()}/#{resource}"
      end

    {uri, body} =
      case method do
        :get ->
          if is_nil(body) do
            {uri, nil}
          else
            uri =
              body
              |> Enum.reduce(uri, fn {key, value}, uri ->
                if String.contains?(uri, "?") do
                  "#{uri}&#{key}=#{value}"
                else
                  "#{uri}?#{key}=#{value}"
                end
              end)

            {uri, nil}
          end

        _ ->
          {uri, body}
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
