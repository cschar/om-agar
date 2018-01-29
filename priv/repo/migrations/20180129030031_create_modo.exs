defmodule Om.Repo.Migrations.CreateModo do
  use Ecto.Migration

  def change do
    create table(:modos) do
      add :description, :string
      add :complete, :boolean, default: false, null: false

      timestamps()
    end
  end
end
