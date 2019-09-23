defmodule Paggi.Macros.Delete do
  @moduledoc """
  This module holds the top level logic for any delete functions
  """

  @doc """
  Delete resource by ID
  """
  defmacro __using__(_opts) do
    quote do
      def delete(id) when is_binary(id) do
        Paggi.Requester.make_request(:delete, @resource, id)
        |> manage_response()
      end
    end
  end
end
