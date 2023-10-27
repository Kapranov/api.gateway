# Connector

**TODO: Add description**

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

### 27 Oct 2023 by Oleg G.Kapranov

[1]:  https://hexdocs.pm/tesla/1.8.0/readme.html
[2]:  http://httpbin.org
[3]:  https://github.com/saneery/viberex
[4]:  https://medium.com/@anatolyniky/how-to-create-viber-bot-with-elixir-2ff079f989e6
[5]:  https://github.com/chulkilee/ex_force/blob/main/lib/ex_force/client/tesla/tesla.ex
[6]:  https://elixirforum.com/t/guides-to-making-a-library-to-wrap-an-api/20795/2
[7]:  https://github.com/cambiatus/eosrpc-elixir-wrapper/blob/master/test/eosrpc/middleware/error_test.exs
[8]:  https://stackoverflow.com/questions/53524611/how-to-make-post-request-using-tesla-in-elixir
[9]:  https://mrdotb.com/posts/probuild-ex-part-one
[10]: https://blog.lelonek.me/how-to-mock-httpoison-in-elixir-7947917a9266
[11]: https://hexdocs.pm/ex_mono_wrapper/api-reference.html
