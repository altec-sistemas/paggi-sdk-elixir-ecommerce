defmodule Paggi.Macros.Cancel do
  @moduledoc """
  This module holds the top level logic for any cancel functions
  """

  @doc """
  Cancel resource by his ID
  """
  defmacro __using__(_opts) do
    quote do
      alias Paggi.Requester

      def cancel(id) when is_binary(id) do
        Requester.make_request(:put, @resource, id, nil, "/void")
        |> manage_response()
      end
    end
  end
end
