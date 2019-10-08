defmodule Paggi.Resources.Orders do
  @moduledoc """
  Paggi's Orders resource
  """
  use Paggi.Resource
  use Paggi.Macros.{Find, Cancel, Capture, Create}
end
