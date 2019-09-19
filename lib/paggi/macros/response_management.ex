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
        body
        |> Poison.decode()
        |> case do
          {:ok, %{"entries" => entries} = body} ->
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

          {:ok, body} ->
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

          {:error, reason} ->
            {:error, %Paggi.Error{
              code: 500,
              message: reason
            }}
        end
      end
    end
  end
end
