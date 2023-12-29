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

### 29 Dec 2023 by Oleg G.Kapranov

[1]: https://github.com/elixir-lang/elixir/blob/v1.11.4/lib/elixir/lib/map.ex
[2]: https://github.com/bencheeorg/benchee/blob/main/lib/benchee.ex
