defmodule Core.Bench.Setting do
  use Ecto.Schema

  schema "settings" do
    field(:param, :string)
    field(:value, :string)
    field(:uuid, :binary_id)
  end

  @required_attrs [
    :param,
    :value,
    :uuid
  ]

  def changeset() do
    changeset(sample_data())
  end

  def changeset(data) do
    Ecto.Changeset.cast(%__MODULE__{}, data, @required_attrs)
  end

  def sample_data do
    %{
      param: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      value: "foobar@email.com",
      uuid: Ecto.UUID.generate()
    }
  end
end

defmodule Core.Bench.Game do
  use Ecto.Schema

  schema "games" do
    field(:name, :string)
    field(:price, :float)
  end
end
