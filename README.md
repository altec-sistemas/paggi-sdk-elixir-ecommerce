# Paggi Elixir SDK - Ecommerce [![Build Status](https://drone.altec.ai/api/badges/altec-sistemas/paggi-sdk-elixir-ecommerce/status.svg)](https://drone.altec.ai/altec-sistemas/paggi-sdk-elixir-ecommerce)

Utilize este SDK para realizar a integração com nossa API de ecommerce.

## Instalação

```elixir
{:paggi, git: "altec-sistemas/paggi-sdk-elixir-ecommerce", tag: "v1.0.2"}
```

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

## Utilização

### Cartões:

```elixir
alias Paggi.Resources.Cards

> Criar cartão:

{:ok, card} = Cards.create %{
  "cvc" => "123",
  "year" => "2022",
  "number" => "4123200700046446",
  "month" => "09",
  "holder" => "BRUCE WAYNER",
  "document" => "16123541090"
}

> Consultar cartões por cliente:

{:ok, cards} = Cards.find %{
  "document" => "16123541090"
}


> Deletar cartão:

{:ok, card} = Cards.delete %{
  "card_id" => "7f42a0a0-6ae8-4a57-a340-a8c4867771eb"
}
```

### Pedidos

```elixir
alias Paggi.Resources.Orders

> Criar pagamento:

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

> Cancelar pagamento:

order_id = "ffe22540-ebf2-4415-92af-56b2cf80bf9e"

{:ok, order} =  Orders.cancel(order_id)

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

> Buscar recebedor:

{:ok, recipient} = Recipients.find()


> Atualizar recebedor:

{:ok, recipient} = Recipients.update %{
  "name" => "BRUCE WAYNER",
  "document" => "78945612389",
  "bank_account" => %{
    "bank_code" => "077",
    "branch_number" => "0123",
    "branch_digit" => "4",
    "account_number" => "330233",
    "account_digit" => "7",
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


### Planos / Assinaturas

Para criar uma assinatura é necessário um plano existente.
O Plano controla o valor, intervalo entre pagamentos, duração, período de teste da assinatura.
A Assinatura é responsável pelo pagamento, assim como desconto e preços adicionais se necessário.

```elixir
alias Paggi.Resources.{Subscriptions, Plans}

> Criar plano:

{:ok, plan} = Plans.create %{
  "name" => "Meu primeiro plano",
  "price" => 1990,
  "interval" => "1m",
  "trial_period" => "2d",
  "external_identifier" => "12345",
  "description"=> "Teste"
}

> Criar assinatura:

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


> Consultar plano:

{:ok, plan} = Plan.find %{
   "plan_id" => "7f42a0a0-6ae8-4a57-a340-a8c4867771eb"
}


> Atualizar plano: 

{:ok, plan} = Plan.update %{
   "plan_id" => "7f42a0a0-6ae8-4a57-a340-a8c4867771eb",
   "price" => 2990
}


> Cancelar assinatura:

{:ok, subscription} = Subscriptions.delete %{
  "subscription_id" => "cae4fd53-2169-4b5f-ac48-026fade071ae"
}
```

### Mais informações

Para mais informação, você pode conferir nossa documentação [aqui](https://developers.paggi.com/).
