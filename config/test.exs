import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oIy4/YmJHGDVk2tEgA5WfQ6osG9xCaWpD2Q4LqaFzmIFiA5iK9aHwLwuhFyB6Led",
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oebnq+gj1DORIC9ULxTjwoCD0zhffg1+OBzHre06PfH3mWM48bR4Ah6amkyb2QmH",
  server: false
