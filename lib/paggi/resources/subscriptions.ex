defmodule Paggi.Resources.Subscriptions do
  @moduledoc """
  Paggi's Subscriptions resource
  """
  use Paggi.Resource
  use Paggi.Macros.{Find, Create, Update, Cancel}
end
