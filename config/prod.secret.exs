import Config

config :gateway, Gateway.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [host: "example.com", port: 80]
