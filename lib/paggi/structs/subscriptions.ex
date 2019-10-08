defmodule Paggi.Structs.Subscriptions do
  defstruct [
    :id,
    :status,
    :customer,
    :current_charge,
    :inserted_at,
    :charges,
    :additionals,
    :discounts,
    :in_trial,
    :in_overdue
  ]
end

defmodule Paggi.Structs.Subscriptions.Additionals do
  defstruct [
    :inserted_at,
    :period,
    :amount,
    :description
  ]
end

defmodule Paggi.Structs.Subscriptions.Discounts do
  defstruct [
    :inserted_at,
    :period,
    :amount,
    :description
  ]
end

defmodule Paggi.Structs.Subscriptions.Charges do
  defstruct [
    :id,
    :amount,
    :card_id,
    :installments,
    :statuses
  ]
end

defmodule Paggi.Structs.Subscriptions.CurrentCharge do
  defstruct [
    :id,
    :amount,
    :card_id,
    :installments,
    :statuses
  ]
end

defmodule Paggi.Structs.Subscriptions.Customer do
  defstruct [
    :document,
    :email,
    :name
  ]
end

defmodule Paggi.Structs.Subscriptions.Charges.Statuses do
  defstruct [
    :amount,
    :inserted_at,
    :reason,
    :type
  ]
end

defmodule Paggi.Structs.Subscriptions.CurrentCharge.Statuses do
  defstruct [
    :amount,
    :inserted_at,
    :reason,
    :type
  ]
end
