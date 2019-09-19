defmodule Paggi.Structs.Orders do
  defstruct [
    :id,
    :external_identifier,
    :recipients,
    :customer,
    :charges,
    :status,
    :inserted_at,
    :updated_at
  ]
end
