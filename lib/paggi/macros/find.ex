defmodule Paggi.Macros.Find do
  @moduledoc """
  This module holds the top level logic for any find functions
  """

  @doc """
  Find all of a given resource or find by ID
  """
  defmacro __using__(_opts) do
    quote do
      def retrieve_one(id) when is_binary(id) do
        Paggi.Requester.make_request(:get, @resource, id)
        |> manage_response()
      end

      def retrieve_all(params) when is_map(params) do
        Paggi.Requester.make_request(:get, @resource, nil, params)
        |> manage_response()
      end
      def retrieve_all() do
        Paggi.Requester.make_request(:get, @resource)
        |> manage_response()
      end
    end
  end
end
