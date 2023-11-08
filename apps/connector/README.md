# Connector

**TODO: Add description**

- Priority of Policy

DIA
INTERTELECOM
KYIVSTAR
LIFECELL
TELEGRAM
TIMEOUT
VIBER
VODAFONE

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
      ### created sms_logs, priority: number
      ###
      {:ok, []}
    {:ok, struct} ->
      #############
      ### Policy

      ONLY settings is recored "calc_priority"
      1. settings, param: "calc_priority", value: "priority", "price", "priceext_priceint"
         when none via front-end via => sms_logs ???
      ONLY operator, active: true
      2. if "calc_priority" => "priority"          => sort operators by field's :priority (Integer ASC)
         => Core.Queries.sort_priority(structs)
      3. if "calc_priority" => "price"             => sort operators by :price_ext (Decimal ASC)
         => Core.Queries.sort_price_ext(structs)
      4. if "calc_priority" => "priceext_priceint" => take args.phone_number(099)
          select operators by :phone_code search args.phone_number(099) => list_operators(099) (ASC :price_int)
          select operators by :phone_code != (099)  => list_operators(none 099) (ASC :price_ext)
          join list_operators(099) ++ list_operators(none 099) => join_list_operator
         join_list_operator
         => Core.Queries.sort_priceext_priceint(phone_number)
      5. create Connector - dia, intertelecom, kyivstar, lifecell, telegram, viber, vodafone, SMTP
      - send to connector

      -----------------------------
       list_ready_send_for_operator

       1. take first from list config  (via connector)
       2. save recorded to sms_logs priority: num
       3. send on connector (take name connector via config)
         - %{status: "send"}
         - :timeout
         - :error
       4. updated recorded to messages when  %{status: "send", id: "xxx"}
          - after 10s -> take id send on connector via operator => %{status: "send", id: "xxx"} - "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id
          - after 5s -> status: "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id
          - after 5s -> status: "send", "delivered" or "error"
            - "delivered" => updated message status: "delivered", updated sms_logs status_id
            - "error"     => updated message status "error", updated sms_logs status_id

       5."send"  => when none delivered take next operator
         "error" => when none delivered take next operator
       6. take id send on connector via operator

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

### 27 Oct 2023 by Oleg G.Kapranov

[1]:  http://httpbin.org
[2]:  https://blog.lelonek.me/how-to-mock-httpoison-in-elixir-7947917a9266
[3]:  https://elixirforum.com/t/guides-to-making-a-library-to-wrap-an-api/20795/2
[4]:  https://github.com/brianmay/ex_tesla/blob/master/lib/ex_tesla/api.ex
[5]:  https://github.com/cambiatus/eosrpc-elixir-wrapper/blob/master/test/eosrpc/middleware/error_test.exs
[6]:  https://github.com/chulkilee/ex_force/blob/main/lib/ex_force/client/tesla/tesla.ex
[7]:  https://github.com/saneery/viberex
[8]:  https://hexdocs.pm/ex_mono_wrapper/api-reference.html
[9]:  https://hexdocs.pm/tesla/1.8.0/readme.html
[10]: https://medium.com/@anatolyniky/how-to-create-viber-bot-with-elixir-2ff079f989e6
[11]: https://medium.com/@russbredihin/building-an-api-wrapper-with-elixir-and-tesla-468889ce820
[12]: https://mrdotb.com/posts/probuild-ex-part-one
[13]: https://stackoverflow.com/questions/53524611/how-to-make-post-request-using-tesla-in-elixir
[14]: https://elixirforum.com/t/please-help-me-to-convert-curl-request-to-tesla-post-request/37509
[15]: https://copyprogramming.com/howto/how-to-make-post-request-using-tesla-in-elixir
[16]: https://gitlab.com/adamwight/mediawiki_client_ex/-/blob/main/lib/action.ex
