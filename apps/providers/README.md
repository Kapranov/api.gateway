# Providers

**TODO: Add description**

```
bash> mix new providers --sup
```

```

alias Gateway.GraphQL.Resolvers.Home.IndexPageResolver
alias Gateway.GraphQL.Resolvers.Spring.MessageResolver

{:ok, token} = IndexPageResolver.token(nil, nil, nil)
context = %{context: %{token: token}}

args = %{
  message_body: "some text",
  phone_number: "+380991111111",
  status_id: "xxx"
}

{:ok, created} = MessageResolver.create(nil, args, context)

create list for priorities

1. settings, param: "calc_priority", value: "priority", "price", "priceext_priceint"
2. operator, active: true
3. if "calc_priority" => "priority"          => sort operators by field's :priority (Integer ASC)
4. if "calc_priority" => "price"             => sort operators by :price_ext (Decimal ASC)
5. if "calc_priority" => "priceext_priceint" => take args.phone_number(099)
    select operators by :phone_code search args.phone_number(099) => list_operators(099) (ASC :price_int)
    select operators by :phone_code != (099)  => list_operators(none 099) (ASC :price_ext)
    join list_operators(099) ++ list_operators(none 099) => join_list_operator
6. join_list_operator => send on connector
7. create Connector - dia, intertelecom, kyivstar, lifecell, telegram, viber, vodafone, SMTP
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

[1]:  https://docs.google.com/document/d/1XvcrLli9VLtYWS5G-Dnu4j2Ul72bP9cd/edit
[2]:  https://github.com/edgurgel/httpoison
[3]:  https://github.com/edgurgel/httpoison/issues/181
[4]:  https://github.com/edgurgel/httpoison/issues/317
[5]:  https://github.com/shhavel/uri_query
