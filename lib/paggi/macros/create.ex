defmodule Paggi.Macros.Create do
  @moduledoc """
  This module holds the top level logic for any create functions
  """

  @doc """
  Create a new resource
  """
  defmacro __using__(_opts) do
    quote do
      def create(params) when is_map(params) do
        Paggi.Requester.make_request(:post, @resource, nil, params)
        |> manage_response()
      end
    end
  end
end
