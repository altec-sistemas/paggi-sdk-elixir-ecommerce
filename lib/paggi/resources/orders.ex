defmodule Paggi.Resources.Orders do
  @moduledoc """
  Paggi's Orders resource
  """
  use Paggi.Resource
  use Paggi.Macros.{Cancel, Capture, Create}
end
