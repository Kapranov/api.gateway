# Connector

**TODO: Add description**

- Priority of Policy

* DIA
* INTERTELECOM
* KYIVSTAR
* LIFECELL
* TELEGRAM
* TIMEOUT
* VIBER
* VODAFONE

- Create Message

```elixir

args =>
  arg :message_body, non_null(:string) => "Код рецепту - 34568"
  arg :phone_number, non_null(:string) => "+380984263462"
  arg :status_id,    non_null(:string) => "status_name" => "new", "status_code" => 101


@spec create(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
def create(_parent, args, %{context: %{token: _token}}) do
  args
  |> Spring.create_message()
  |> case do
    {:error, %Ecto.Changeset{}} ->
      ###
DONE  ### created sms_logs, priority: number
      ###
      {:ok, []}
    {:ok, struct} ->
      #############
      ### Policy

      ONLY settings is recored "calc_priority"
DONE  1. settings, param: "calc_priority", value: "priority", "price", "priceext_priceint"
         when none via front-end via => sms_logs ???
DONE  ONLY operator, active: true
DONE  2. if "calc_priority" => "priority"          => sort operators by field's :priority (Integer ASC)
         => Core.Queries.sort_priority(structs)
DONE  3. if "calc_priority" => "price"             => sort operators by :price_ext (Decimal ASC)
         => Core.Queries.sort_price_ext(structs)
DONE  4. if "calc_priority" => "priceext_priceint" => take args.phone_number(099)
        select operators by :phone_code search args.phone_number(099) => list_operators(099) (ASC :price_int)
        select operators by :phone_code != (099)  => list_operators(none 099) (ASC :price_ext)
        join list_operators(099) ++ list_operators(none 099) => join_list_operator
        join_list_operator
        => Core.Queries.sort_priceext_priceint(phone_number)
DONE  5. create Connector - dia, intertelecom, kyivstar, lifecell, telegram, viber, vodafone, SMTP
         - send to connector

      -----------------------------------
      NEXT - list_ready_send_for_operator
      -----------------------------------

DONE   1. take first from list config  (via connector)
DONE   2. save recorded to sms_logs priority: num
DONE   3. send on connector (take name connector via config)
         - %{status: "send"}
         - :timeout
         - :error
DONE   4. updated recorded to messages when  %{status: "send", id: "xxx"}
          - after 10s -> take id send on connector via operator => %{status: "send", id: "xxx"} - "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id
          - after 5s -> status: "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id
          - after 5s -> status: "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id

DONE   5.   "send" => when none delivered take next operator
           "error" => when none delivered take next operator
         "timeout" => when none delivered take next operator
DONE   6. take id send on connector via operator

      ###
      #############
      {:ok, struct}
  end
end
```



```bash
bash> mix new connector --sup
```

```elixir
iex> Connector.Dia.send
{:ok, %{"status" => "send"}}
iex> Connector.Intertelecom.send
{:ok, %{"status" => "send"}}
iex> Connector.Kyivstar.send
{:ok, %{"status" => "send"}}
iex> Connector.Lifecell.send
{:ok, %{"status" => "send"}}
iex> Connector.Telegram.send
{:ok, %{"status" => "error"}}
iex> Connector.Viber.send
{:ok, %{"status" => "send"}}
iex> Connector.Vodafone.send
{:ok, %{"status" => "error"}}
```

```elixir
iex> {:ok, server} = Connector.VodafoneHandler.start_link([{"Ab7ug1IoIJuRlzVjpw"}])
iex> Connector.VodafoneHandler.get_status(server, 1_000)
%{status: "send", text: "Ваш код - 7777-999-9999-10003", sms: "+380984263462"}
iex> :sys.get_state(server)
%{status: "send", text: "Ваш код - 7777-999-9999-10003", sms: "+380984263462"}
iex> Connector.VodafoneHandler.stop(server)
:ok

iex> {:ok, server} = Connector.VodafoneHandler.start_link([{"Ab7ug1IoIJuRlzVjpw"}])
iex> Connector.VodafoneHandler.get_status(server, 1_000)
iex> :timeout
iex> :sys.get_state(server)
iex> :timeout
iex> Connector.VodafoneHandler.stop(server)
:ok

iex> {:ok, server} = Connector.VodafoneHandler.start_link([{"Ab7ug1IoIJuRlzVjpw"}])
iex> Connector.VodafoneHandler.get_status("Ab7ug1IoIJuRlzVjpw")
%{status: "send", text: "Ваш код - 7777-999-9999-10003", sms: "+380984263462"}
iex> :sys.get_state(server)
%{status: "send", text: "Ваш код - 7777-999-9999-10003", sms: "+380984263462"}
iex> Connector.VodafoneHandler.stop(server)
:ok

iex> {:ok, server} = Connector.VodafoneHandler.start_link([{"Ab7ug1IoIJuRlzVjpw"}])
iex> Connector.VodafoneHandler.get_status("Ab7ug0vPhJC6bQZ3Mu")
iex> :timeout
iex> :sys.get_state(server)
iex> :timeout
iex> Connector.VodafoneHandler.stop(server)
:ok

iex> {:ok, server} = Connector.VodafoneHandler.start_link([{FlakeId.get}])
{:ok, #PID<0.551.0>}
iex> Connector.VodafoneHandler.get_status(server, 1_000)
:error
iex> :sys.get_state(server)
:error
iex> Process.info(server)
iex> Process.exit(server, :kill)
iex> Process.info(server)
nil

iex> {:ok, server} = Connector.VodafoneHandler.start_link([{FlakeId.get}])
{:ok, #PID<0.645.0>}
iex> Connector.VodafoneHandler.get_status(server, 1_000)
:error
iex> :sys.get_state(server)
:error
iex> Connector.VodafoneHandler.stop(server)
:ok
iex> Process.info(server)
nil
```

```elxir
# Kill the current process after 2 seconds
iex> :timer.kill_after(:timer.seconds(2))
# Kill pid after 2 minutes
:timer.kill_after(:timer.minutes(2), pid)
```

```
iex> phone_number = "+380997171111"
iex> message_id = Core.Repo.all(Core.Spring.Message) |> List.last |> Map.get(:id)
iex> operators =  Core.Queries.sorted_by_operators(phone_number)
iex> Gateway.GraphQL.Resolvers.Spring.MessageResolver.selected_connector(operators, message_id)
iex> Gateway.GraphQL.Resolvers.Spring.MessageResolver.selected_connector(operators, FlakeId.get)
```

### Notes for field `active` is `true` to allow only one record for `false` one and a more records

```
iex> grouped = Enum.group_by(operators, fn x -> x.config.name end)
iex> grouped["vodafone"] |> List.first
```

### Kafka

```bash
bash> sudo -u kafka /opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic MyTopic
bash> sudo -u kafka /opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic kaffe-test
bash> sudo -u kafka /opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

bash> sudo -u kafka /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic MyTopic
bash> sudo -u kafka /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic MyTopic --from-beginning
```

```
iex> Logger.log(:info, "Run took #{run_end - run_start} ms, #{messages_count} messages, #{messages_sec} msg/sec")
```

```
iex> {:ok, server} = Connector.Monitor.start_link([])
iex> :sys.get_state(server)
iex> :sys.get_status(server)
iex> Process.whereis(KaffeMonitor) == server
iex> id = "Ac7y2LxiD9lsV2Oeiu"
iex> topic = "MyTopic"
iex> message = ~s({"status":"send","text":"Ваш код - 7777-999-9999-9999 - vodafone","connector":"vodafone","sms":"+380991111111","ts":#{:os.system_time(:milli_seconds)}})
iex> messages = [%{key: id, value: message}]
iex> Connector.Monitor.produce(topic, messages)
```

### 27 Oct 2023 by Oleg G.Kapranov

 [1]: http://httpbin.org
 [2]: https://blog.lelonek.me/how-to-mock-httpoison-in-elixir-7947917a9266
 [3]: https://copyprogramming.com/howto/how-to-make-post-request-using-tesla-in-elixir
 [4]: https://elixirforum.com/t/guides-to-making-a-library-to-wrap-an-api/20795/2
 [5]: https://elixirforum.com/t/please-help-me-to-convert-curl-request-to-tesla-post-request/37509
 [6]: https://github.com/brianmay/ex_tesla/blob/master/lib/ex_tesla/api.ex
 [7]: https://github.com/cambiatus/eosrpc-elixir-wrapper/blob/master/test/eosrpc/middleware/error_test.exs
 [8]: https://github.com/chulkilee/ex_force/blob/main/lib/ex_force/client/tesla/tesla.ex
 [9]: https://github.com/saneery/viberex
[10]: https://gitlab.com/adamwight/mediawiki_client_ex/-/blob/main/lib/action.ex
[11]: https://hexdocs.pm/ex_mono_wrapper/api-reference.html
[12]: https://hexdocs.pm/tesla/1.8.0/readme.html
[13]: https://medium.com/@anatolyniky/how-to-create-viber-bot-with-elixir-2ff079f989e6
[14]: https://medium.com/@russbredihin/building-an-api-wrapper-with-elixir-and-tesla-468889ce820
[15]: https://mrdotb.com/posts/probuild-ex-part-one
[16]: https://stackoverflow.com/questions/53524611/how-to-make-post-request-using-tesla-in-elixir
[17]: https://gist.github.com/IanVaughan/1b3f14b430bb8480e07e2d8c9d48d94d
[18]: https://github.com/thure/so-genserver-timeout/blob/master/lib/parent.ex
[19]: https://github.com/TheFirstAvenger/ets/blob/master/lib/ets/base.ex
[20]: https://elixirforum.com/t/waiting-for-multiple-tasks-in-a-genserver/57031
[21]: https://github.com/gottfrois/tus/blob/master/lib/tus/cache/memory.ex
[22]: https://gist.github.com/gottfrois
[23]: https://medium.com/@carlogilmar/process-in-elixir-a-simple-example-d5522028ee7b
[24]: https://hexdocs.pm/timeout/readme.html
[25]: https://bitwalker.org/posts/2018-03-18-functional-imperative-programming-with-elixir/
[26]: https://bitwalker.org/posts/2018-03-18-functional-imperative-programming-with-elixir/
[27]: https://dockyard.com/blog/2020/01/31/state-timeouts-with-gen_statem
[28]: https://thoughtbot.com/blog/how-to-start-processes-with-dynamic-names-in-elixir
[29]: https://github.com/spreedly/kaffe/issues/93
[30]: https://hexdocs.pm/elixir/main/dynamic-supervisor.html
[31]: https://thoughtbot.com/blog/how-to-start-processes-with-dynamic-names-in-elixir
[32]: https://www.thegreatcodeadventure.com/how-we-used-elixirs-genservers-dynamic-supervisors-to-build-concurrent-fault-tolerant-workflows/
