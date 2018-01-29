defmodule Om.ModoTest do
  use Om.ModelCase

  alias Om.Modo

  @valid_attrs %{complete: true, description: "some description"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Modo.changeset(%Modo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Modo.changeset(%Modo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
