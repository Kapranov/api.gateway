import Config

config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oIy4/YmJHGDVk2tEgA5WfQ6osG9xCaWpD2Q4LqaFzmIFiA5iK9aHwLwuhFyB6Led",
  server: false
