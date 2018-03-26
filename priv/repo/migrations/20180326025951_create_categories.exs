defmodule Om.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string

      timestamps()
    end

    # added in manually
    create unique_index(:categories, [:name])

  end
end
