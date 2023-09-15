defmodule Core.Monitoring.Status do
  @moduledoc """
  Schema for Status.
  """

  use Core.Model

  @type t :: %__MODULE__{
    id: String.t(),
    active: boolean,
    description: String.t(),
    inserted_at: DateTime.t(),
    status_name: String.t(),
    status_code: integer
  }

  @min_chars 5
  @max_chars 100

  @allowed_params ~w(
    active
    description
    inserted_at
    status_name
    status_code
  )a

  @required_params ~w(
    active
    status_name
    status_code
  )a

  schema "statuses" do
    field :active, :boolean, default: true
    field :description, :string
    field :status_name, :string
    field :status_code, :integer

    timestamps(updated_at: false)
  end

  @doc """
  Create changeset for Status.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: @min_chars, max: @max_chars)
    |> validate_length(:status_name, min: @min_chars, max: @max_chars)
    |> validate_inclusion(:status_code, 1..99)
    |> foreign_key_constraint(:status_code, message: "Select the StatusCode")
    |> unique_constraint(:status_code, name: :statuses_status_code_index)
  end
end

