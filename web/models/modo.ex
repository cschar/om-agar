defmodule Om.Modo do
  use Om.Web, :model

  schema "modos" do
    field :description, :string
    field :complete, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :complete])
    |> validate_required([:description, :complete])
  end
end
