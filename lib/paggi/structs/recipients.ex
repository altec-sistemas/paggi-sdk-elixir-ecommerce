defmodule Paggi.Structs.Recipients do
  defstruct [
    :id,
    :name,
    :partner,
    :partner_id,
    :document,
    :identifier,
    :bank_account
  ]
end

defmodule Paggi.Structs.Recipients.BankAccount do
  defstruct [
    :id,
    :bank,
    :account_holder_name,
    :account_digit,
    :account_number,
    :account_type,
    :branch_digit,
    :branch_number,
    :document
  ]
end

defmodule Paggi.Structs.Recipients.BankAccount.Bank do
  defstruct [
    :bank_code,
    :bank_name,
    :bank_ispb
  ]
end
