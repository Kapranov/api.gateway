defmodule Core.Settings do
  @moduledoc """
  The Settings context.
  """

  use Core.Context

  alias Core.{
    Settings.Setting,
    Repo
  }

  @doc """
  Returns the list of Setting.
  """
  @spec list_setting() :: [Setting.t()]
  def list_setting, do: Repo.all(Setting)

  @doc """
  Gets a single Setting.

  Raises `Ecto.NoResultsError` if an Addon does not exist.

  ## Examples

      iex> get_setting(123)
      %Setting{}

      iex> get_setting(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_setting(String.t()) :: Setting.t() | error_tuple()
  def get_setting(id), do: Repo.get!(Setting, id)

  @doc """
  Creates Setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_setting(%{atom => any}) :: result() | error_tuple()
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates Setting.

  ## Examples

      iex> update_setting(struct, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_setting(Setting.t(), %{atom => any}) :: result() | error_tuple()
  def update_setting(%Setting{} = struct, attrs) do
    struct
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Setting Changes.

  ## Examples

      iex> change_setting(struct)
      %Ecto.Changeset{source: %Setting{}}

  """
  @spec change_setting(Setting.t()) :: Ecto.Changeset.t()
  def change_setting(%Setting{} = struct) do
    Setting.changeset(struct, %{})
  end
end
