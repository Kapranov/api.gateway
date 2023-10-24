# Providers

**TODO: Add description**

```
bash> mix new providers --sup
```

## For `Providers.Dia`

```elixir
console> data = Providers.Dia.auth
console> token = elem(data, 1)
console> data  = Providers.Dia.template(token)
console> template_id = elem(data, 1)
console> Providers.Dia.register(token, template_id)
```

### 24 Oct 2023 by Oleg G.Kapranov

[1]: https://docs.google.com/document/d/1XvcrLli9VLtYWS5G-Dnu4j2Ul72bP9cd/edit
[2]: https://github.com/edgurgel/httpoison
[3]: https://github.com/edgurgel/httpoison/issues/317
[4]: https://github.com/edgurgel/httpoison/issues/181
[5]: https://github.com/shhavel/uri_query
