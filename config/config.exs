use Mix.Config

config :paggi, Paggi,
  environment: {:system, "PAGGI_ENVIRONMENT"},
  token: {:system, "PAGGI_TOKEN"},
  version: {:system, "PAGGI_VERSION"}
