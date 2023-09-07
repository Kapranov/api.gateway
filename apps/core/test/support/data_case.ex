defmodule Core.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Core.Repo
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter
  alias Ecto.Changeset

  using do
    quote do
      alias Core.Repo

      import Ecto
      import Ecto.{
        Changeset,
        Multi,
        Query
      }
      import Core.DataCase
      import Core.Factory
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo)

    unless tags[:async], do: Adapter.mode(Repo, {:shared, self()})

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  @spec errors_on(Ecto.Changeset.t()) :: %{atom => any}
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @doc """
  Asserts if a specific error message has been added to a specific field on the
  changeset. It is more flexible to use `error_message/2` directly instead of
  this one.

  ```
  assert_error_message(changeset, :foo, "bar")
  ```

  Compared to

  ```
  assert error_message(changeset, :foo) ==  "bar"
  refute error_message?(changeset, :foo) ==  "baz"
  ```
  """
  @spec assert_error_message(Ecto.Changeset.t(), Atom.t(), String.t()) :: boolean()
  def assert_error_message(changeset, field, expected_message) do
    assert error_message(changeset, field) == expected_message
  end

  @doc """
  Asserts if a specific validation type has been triggered on a specific field
  on the changeset. It is more flexible to use `validation_triggered/2` directly
  instead of this one.

  ```
  assert_validation_triggered(changeset, :foo, "bar")
  ```

  Compared to

  ```
  assert validation_triggered(changeset, :foo) ==  :required
  refute validation_triggered?(changeset, :bar) ==  :required
  ```
  """
  @spec assert_validation_triggered(Ecto.Changeset.t(), Atom.t(), Atom.t()) :: boolean()
  def assert_validation_triggered(changeset, field, type) do
    assert validation_triggered(changeset, field) == type
  end

  @doc """
  Returns an atom indicating the type of validation that was triggered on a
  field in a changeset.
  """
  @spec validation_triggered(Ecto.Changeset.t(), Atom.t()) :: Atom.t()
  def validation_triggered(changeset, field) do
    {_message, status} = changeset.errors[field]
    status[:validation]
  end

  @doc """
  Returns true or false depending on if an assoc_constraint validation has been
  triggered in the provided changeset on the specified field.
  """
  @spec assoc_constraint_triggered?(Ecto.Changeset.t(), Atom.t()) :: boolean()
  def assoc_constraint_triggered?(changeset, field) do
    error_message(changeset, field) == "does not exist"
  end

  @doc """
  Returns an error message on a specific field on the specified changeset
  """
  @spec error_message(Ecto.Changeset.t(), Atom.t()) :: String.t()
  def error_message(changeset, field) do
    {message, _} = changeset.errors[field]
    message
  end
end
