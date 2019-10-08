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

defmodule Paggi.Structs.Orders.Recipients do
  defstruct [
    :id,
    :document,
    :name,
    :amount
  ]
end

defmodule Paggi.Structs.Orders.Customer do
  defstruct [
    :document,
    :email,
    :name
  ]
end

defmodule Paggi.Structs.Orders.Charges do
  defstruct [
    :id,
    :amount,
    :card_id,
    :installments,
    :statuses
  ]
end

defmodule Paggi.Structs.Orders.Charges.Statuses do
  defstruct [
    :amount,
    :inserted_at,
    :reason,
    :type
  ]
end
