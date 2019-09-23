defmodule Paggi.Macros.ResponseManagement do
  @moduledoc """
  This module holds the logic to manage the responses
  """

  @doc """
  Manage all responses from API and populate structs
  """
  defmacro __using__(_opts) do
    quote do
      @namespace "Paggi.Structs"

      defp adjust_value(value) when is_map(value) do
        value
        |> Enum.reduce(%{}, fn {key, value}, map ->
          Map.put(map, String.to_atom(key), adjust_value(value))
        end)
      end
      defp adjust_value(value), do: value

      def manage_response(%Paggi.Response{status_code: 200, body: body, resource: resource}) when is_binary(resource) and is_map(body) do
        case body do
          %{"entries" => entries} = body ->
            entry_struct =
              @namespace
              |> Module.safe_concat(String.capitalize(resource))
              |> struct()

            entries =
              entries
              |> Enum.reduce([], fn entry, structs ->
                entry =
                  entry
                  |> Enum.reduce(entry_struct, fn {key, value}, struct ->
                    key = String.to_atom(key)

                    if Map.has_key?(struct, key) do
                      Map.put(struct, key, adjust_value(value))
                    else
                      struct
                    end
                  end)
                structs ++ [entry]
              end)

            body =
              body
              |> Map.delete("entries")
              |> Enum.reduce(%{}, fn {key, value}, map ->
                Map.put(map, String.to_atom(key), adjust_value(value))
              end)
              |> Map.put(:entries, entries)

            {:ok, body}

          body ->
            struct =
              @namespace
              |> Module.safe_concat(String.capitalize(resource))
              |> struct()

            struct =
              body
              |> Enum.reduce(struct, fn {key, value}, struct ->
                key = String.to_atom(key)

                if Map.has_key?(struct, key) do
                  Map.put(struct, key, adjust_value(value))
                else
                  struct
                end
              end)

            {:ok, struct}
        end
      end
      def manage_response(%Paggi.Response{status_code: 201, body: body, resource: resource}) when is_binary(resource) and is_binary(body) do
        struct =
          @namespace
          |> Module.safe_concat(String.capitalize(resource))
          |> struct()

        struct =
          body
          |> Enum.reduce(struct, fn {key, value}, struct ->
            key = String.to_atom(key)

            if Map.has_key?(struct, key) do
              Map.put(struct, key, adjust_value(value))
            else
              struct
            end
          end)

        {:ok, struct}
      end
      def manage_response(%Paggi.Response{status_code: 204} = response), do: {:ok, response}
      def manage_response(%Paggi.Response{status_code: 400}), do: {:error, %Paggi.Error{code: 400, message: "Algum parâmetro ou cabeçalho HTTP está ausente"}}
      def manage_response(%Paggi.Response{status_code: 401}), do: {:error, %Paggi.Error{code: 401, message: "Não autorizada"}}
      def manage_response(%Paggi.Response{status_code: 402}), do: {:error, %Paggi.Error{code: 402, message: "Uma ou mais cobranças foram negadas"}}
      def manage_response(%Paggi.Response{status_code: 404}), do: {:error, %Paggi.Error{code: 404, message: "Objeto não encontrado"}}
      def manage_response(%Paggi.Response{status_code: 422, body: body, resource: resource}) when is_binary(resource) and is_map(body) do
        body
        |> Enum.reduce_while({:ok, []}, fn {key, value}, {:ok, parameters} ->
          key = String.to_atom(key)
          {:cont, {:ok, Map.put(%{}, key, adjust_value(value))}}
        end)
        |> case do
          {:ok, parameters} ->
            {:error, %Paggi.ParameterError{
              code: 422,
              message: "Foi encontrado um erro em algum parâmetro do corpo da requisição",
              parameters: parameters
            }}
        end
      end
      def manage_response(%Paggi.Response{status_code: 500}), do: {:error, %Paggi.Error{code: 500, message: "Erro interno no servidor"}}
      def manage_response(%Paggi.Response{status_code: 501}), do: {:error, %Paggi.Error{code: 501, message: "Este método não é implementado para esse recurso"}}
      def manage_response(%Paggi.Response{status_code: 502}), do: {:error, %Paggi.Error{code: 502, message: "Ocorreu um erro na infraestrutura Paggi"}}
      def manage_response(%Paggi.Response{status_code: 503}), do: {:error, %Paggi.Error{code: 503, message: "Ocorreu um erro na infraestrutura Paggi"}}
      def manage_response(%Paggi.Response{status_code: 504, body: %{"message" => message}}), do: {:error, %Paggi.Error{code: 500, message: message}}
      def manage_response(%Paggi.Response{status_code: 504}), do: {:error, %Paggi.Error{code: 500, message: "Ocorreu um erro ao tentar processar sua solicitação. Verifique se os campos enviados estão corretos"}}
    end
  end
end
