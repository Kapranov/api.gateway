# Core

**TODO: Add description**

```bash
bash> mix new core --sup
bash> mix run apps/core/priv/repo/seeds.exs
```

### `Ecto.Migration`

```sql
```

```bash
bash> mix ecto.gen.migration -r Core.Repo add_uuid_generate_v4_extension
bash> mix ecto.gen.migration -r Core.Repo create_operator_types
bash> mix ecto.gen.migration -r Core.Repo create_operators
bash> mix ecto.gen.migration -r Core.Repo create_statuses
bash> mix ecto.gen.migration -r Core.Repo create_messages
bash> mix ecto.gen.migration -r Core.Repo create_sms_logs
bash> mix ecto.gen.migration -r Core.Repo create_sms_logs_messages
bash> mix ecto.gen.migration -r Core.Repo create_sms_logs_operators
bash> mix ecto.gen.migration -r Core.Repo create_sms_logs_statuses
```

```
iex> message_id = Core.Repo.all(Core.Spring.Message) |> List.first |> Map.get(:id)
iex> operator_id = Core.Repo.all(Core.Operators.Operator) |> List.first |> Map.get(:id)
iex> status_id = Core.Repo.all(Core.Monitoring.Status) |> List.first |> Map.get(:id)
iex> create_log = %{priority: 2, status_changed_at: DateTime.utc_now, messages: message_id, operators: operator_id, statuses: status_id}
iex> Core.Logs.create_sms_log(create_log)
iex> Core.Repo.all(Core.Spring.Message) |> Core.Repo.preload(:sms_logs)
iex> Core.Repo.all(Core.Operators.Operator) |> Core.Repo.preload(:sms_logs)
iex> Core.Repo.all(Core.Monitoring.Status) |> Core.Repo.preload(:sms_logs)
iex> Core.Repo.all(Core.Logs.SmsLog) |> Core.Repo.preload([:messages, :operators, :statuses])
iex> Core.Operators.list_operator
iex> Core.Operators.get_operator("AZr9FuEcmuyPpcWpCD")
iex> Core.Operators.list_operator_type
iex> Core.Operators.get_operator_type("AZr9FtwtqonMweEfZI")
iex> Core.Monitoring.list_status
iex> Core.Monitoring.get_status("AZr9FuT9usbEYhKQqm")
iex> Core.Spring.get_message("AZr9FuaFUWGquge5tw")
iex> Core.Logs.get_sms_log("AZr9KQYbjujWaJQiOW")
iex> Core.Settings.list_setting
```

### Usage EctoAnon

```elixir
iex> setting = Core.Repo.get(Core.Settings.Setting, "AZsyJecvwL9GrrMJHM")
iex> EctoAnon.run(setting, Core.Repo)
```

### 5 September 2023 by Oleg G.Kapranov

 [1]: https://anonyfox.com/spells/ecto-custom-field-validation/
 [2]: https://blog.plataformatec.com.br/2016/12/many-to-many-and-upserts/
 [3]: https://colinramsay.co.uk/2021/02/12/many-to-many-tags-ecto-phoenix.html
 [4]: https://elixirforum.com/t/ecto-insert-many-to-many-with-extra-foreign-key/49556/2
 [5]: https://elixirforum.com/t/many-to-many-association-table-with-extra-columns/6563/12
 [6]: https://elixirschool.com/ru/lessons/ecto/associations#many-to-many-11
 [7]: https://fullstackphoenix.com/tutorials/add-jsonb-field-in-phoenix-and-ecto
 [8]: https://geoffreylessel.com/2017/using-ecto-multi-to-group-database-operations/
 [9]: https://gist.github.com/rylev/6906490
[10]: https://github.com/elixir-ecto/ecto/blob/master/test/ecto/changeset/many_to_many_test.exs
[11]: https://hexdocs.pm/ecto/Ecto.Changeset.html
[12]: https://hexdocs.pm/ecto/Ecto.Multi.html
[13]: https://hexdocs.pm/ecto/composable-transactions-with-multi.html
[14]: https://hexdocs.pm/ecto/polymorphic-associations-with-many-to-many.html
[15]: https://hexdocs.pm/ecto/self-referencing-many-to-many.html
[16]: https://medium.com/@m.r.nijboer/using-ecto-changesets-for-json-api-request-body-validation-6150e8256c5c
[17]: https://medium.com/coletiv-stories/ecto-elixir-many-to-many-relationships-66403933f8c1
[18]: https://medium.com/coletiv-stories/ecto-embedded-schemas-quick-search-through-a-jsonb-array-in-postgresql-f9d91cf90843
[19]: https://smartlogic.io/blog/advanced-ecto-multi-usage/
[20]: https://smartlogic.io/blog/introduction-to-ecto-multi/
