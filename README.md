# Paggi Elixir SDK - Ecommerce [![Build Status](https://drone.altec.ai/api/badges/altec-sistemas/paggi-sdk-elixir-ecommerce/status.svg)](https://drone.altec.ai/altec-sistemas/paggi-sdk-elixir-ecommerce)

Utilize este SDK para realizar a integração com nossa API de ecommerce.

## Instalação

```elixir
{:paggi, git: "altec-sistemas/paggi-sdk-elixir-ecommerce", tag: "v1.0.2"}
```

## Utilização

### Configuração

Você pode utilizar as variáveis de ambiente ou definir diretamente no arquivo de configuração
para que ele possa reconhecer corretamente os teus dados e executar no ambiente correto.

```elixir
# No teu config/config.exs, coloque as configurações da Paggi
use Mix.Config

config :paggi, Paggi,
  environment: {:system, "PAGGI_ENVIRONMENT"}, # staging ou production
  token: {:system, "PAGGI_TOKEN"}, # "ey...."
  version: {:system, "PAGGI_VERSION"} # "v1"
```

### Cartões:

```elixir
alias Paggi.Resources.Cards
{:ok, card} = Cards.create %{
  "cvc" => "123",
  "year" => "2022",
  "number" => "4123200700046446",
  "month" => "09",
  "holder" => "BRUCE WAYNER",
  "document" => "16123541090"
}
```

### Pedidos

```elixir
alias Paggi.Resources.Orders
{:ok, order} = Orders.create %{
  "external_identifier" => "ABC123",
  "ip" => "8.8.8.8",
  "charges" => [
    %{
      "amount" => 5000,
      "installments" => 10,
      "card" => %{
        "cvc" => "123",
        "year" => "2022",
        "number" => "4123200700046446",
        "month" => "09",
        "holder" => "BRUCE WAYNER",
        "document" => "16123541090"
      }
    }
  ],
  "customer" => %{
      "name" => "Bruce Wayne",
      "document" => "86219425006",
      "email" => "bruce@waynecorp.com"
  }
}
```

### Recebedores

O campo `account_type` pode ser:

- CONTA_CORRENTE
- CONTA_POUPANCA
- CONTA_FACIL
- ENTIDADE_PUBLICA


```elixir
alias Paggi.Resources.Recipients
{:ok, recipient} = Recipients.create %{
  "name" => "BRUCE WAYNER",
  "document" => "78945612389",
  "bank_account" => %{
    "bank_code" => "077",
    "branch_number" => "0001",
    "branch_digit" => "5",
    "account_number" => "120003",
    "account_digit" => "4",
    "account_holder_name" => "BRUCE WAYNER",
    "account_type" => "CONTA_CORRENTE"
  }
}
```

### Bancos

```elixir
alias Paggi.Resources.Banks
{:ok, banks} = Banks.retrieve_all %{"start" => 0, "count" => 20}
```

### Planos

```elixir
alias Paggi.Resources.Plans
{:ok, plan} = Plans.create %{
  "name" => "Meu primeiro plano",
  "price" => 1990,
  "interval" => "1m",
  "trial_period" => "2d",
  "external_identifier" => "12345",
  "description"=> "Teste"
}
```

### Assinaturas

```elixir
alias Paggi.Resources.{Subscriptions, Plans}

{:ok, plan} = Plans.create %{
  "name" => "Meu primeiro plano",
  "price" => 1990,
  "interval" => "1m",
  "trial_period" => "2d",
  "external_identifier" => "12345",
  "description"=> "Teste"
}

{:ok, subscription} = Subscriptions.create %{
  "external_identifier" => "Seu ID de assinatura",
   "plan_id" => plan["id"],
   "ip" => "8.8.8.8",
   "customer" => %{
      "name" => "Bruce Wayne",
      "document" => "86219425006",
      "email" => "bruce@waynecorp.com"
   },
   "card" => %{
      "cvc" => "123",
      "year" => "2020",
      "month" => "01",
      "number" => "4485200700046446",
      "holder" => "BRUCE WAYNER",
      "document" => "16223541090"
   },
   "discount" => [
      %{
         "period" => 2,
         "description" => "Teste de discount",
         "amount" => 2000
      }
   ],
   "additional" => [
      %{
         "period" => 3,
         "description" => "Teste de additional",
         "amount" => 1999
      }
   ]
}
```

### Mais informações

Para mais informação, você pode conferir nossa documentação [aqui](https://developers.paggi.com/).
