defmodule Paggi.Macros.Capture do
  @moduledoc """
  This module holds the top level logic for any capture functions
  """

  @doc """
  Capture all of a given resource or find by ID
  """
  defmacro __using__(_opts) do
    quote do
      def capture(id, params \\ nil) when is_binary(id) do
        Paggi.Requester.make_request(:put, @resource, id, params, "/capture")
        |> manage_response()
      end
    end
  end
end
