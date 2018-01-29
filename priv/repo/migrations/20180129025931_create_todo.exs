defmodule Om.Repo.Migrations.CreateTodo do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :description, :string

      timestamps()
    end
  end
end
