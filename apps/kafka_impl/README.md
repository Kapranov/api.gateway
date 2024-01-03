# KafkaImpl

**TODO: Add description**

```elixir
defmodule MyApp.StudentEncryption do
  @moduledoc "Functions to help with encrypting existing data."

  alias MyAppSchemas.Student
  alias Ecto.Changeset
  alias Ecto.Multi

  @doc """
  Encrypt the student data.
  """
  def encrypt(repo) do
    Multi.new()
    |> Multi.put(:students, repo.all(Student))
    |> Multi.merge(&encrypt_students/1)
    |> repo.transaction()
  end

  defp encrypt_students(%{students: students}) do
    Enum.reduce(students, Multi.new(), fn student, multi ->
      Multi.update(multi, {:student, student.id}, Changeset.change(student, %{encrypted_name: student.name}))
    end)
  end
end
```

```elixir
console> {:ok, pid} = KafkaImpl.KafkaMock.start_link
```

```bash
bash> KAKFA_URL="localhost:9092,localhost:9093,localhost:9094" mix test
```


### 29 Dec 2023 by Oleg G.Kapranov

[1]:  https://github.com/Caayu/hydra/blob/main/test/hydra/pickings/core/send_products_to_kafka_test.exs
[2]:  https://github.com/Cyytrus/hydra-ql
[3]:  https://github.com/avvo/kafka_impl
[4]:  https://github.com/avvo/kafkamon
[5]:  https://github.com/avvo/kafkamon/blob/master/lib/kafkamon/topics_subscriber.ex
[6]:  https://github.com/avvo/kafkamon/blob/master/test/kafkamon/reader/event_queue/consumer_test.exs
[7]:  https://github.com/avvo/meta_pid/blob/master/lib/meta_pid.ex
[8]:  https://github.com/bencheeorg/benchee/blob/main/lib/benchee.ex
[9]:  https://github.com/dplummer/kaffeine/blob/master/mix.exs
[10]: https://github.com/elixir-lang/elixir/blob/v1.11.4/lib/elixir/lib/map.ex
[11]: https://github.com/kafka4beam/brod
[12]: https://github.com/kafka4beam/brod/blob/master/guides/examples/elixir/Publisher.md
[13]: https://github.com/kafka4beam/brod/blob/master/src/brod.erl
[14]: https://github.com/kafka4beam/brod/issues/116
[15]: https://github.com/kafka4beam/brod/tree/master/contrib/examples/elixir/lib/brod_sample
[16]: https://github.com/kafkaex/kafka_ex
[17]: https://github.com/satyasyahputra/kafex
[18]: https://github.com/spreedly/kaffe
[19]: https://hexdocs.pm/brod/3.17.0/brod.html
[20]: https://hexdocs.pm/brod/readme.html
[21]: https://hexdocs.pm/kaffe/1.24.0/readme.html
[22]: https://hexdocs.pm/kaffe/readme.html
[23]: https://hexdocs.pm/kafka_ex_tc/0.12.1/readme.html
[24]: https://knowledge.zhaoweiguo.com/build/html/lang/erlangs/opensources/brod
