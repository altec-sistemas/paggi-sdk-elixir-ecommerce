defmodule Paggi.Macros.Update do
  @moduledoc """
  This module holds the top level logic for any update functions
  """

  @doc """
  Update a given resource by ID
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
