defmodule Core.Model do
  @moduledoc """
  Extention Ecto.* for schemas
  """

   alias Core.Repo

   defmacro __using__(_) do
     quote do
       use Ecto.Schema
       import Ecto.Changeset
       import Ecto.Query

       @name __MODULE__

       @primary_key {:id, FlakeId.Ecto.Type, autogenerate: true}
       @foreign_key_type FlakeId.Ecto.Type
       @timestamps_opts [type: :utc_datetime_usec]

       @spec find(String.t()) :: Ecto.Schema.t() | nil
       def find(id) do
         Repo.get(@name, id)
       end

       @spec find_by(String.t()) :: Ecto.Schema.t() | nil
       def find_by(conds) do
         Repo.get_by(@name, conds)
       end

       @spec create(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
       def create(attrs) do
         attrs
         |> changeset()
         |> Repo.insert()
       end

       @spec changeset(map()) :: Ecto.Changeset.t()
       def changeset(attrs) do
         @name.__struct__()
         |> changeset(attrs)
       end
     end
   end
end
