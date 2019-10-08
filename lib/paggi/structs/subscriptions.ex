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
