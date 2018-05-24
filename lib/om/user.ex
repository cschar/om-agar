defmodule Om.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Om.User
                                    # Add this


  schema "users" do
    field :name, :string
    field :email, :string
    has_many :videos, Om.Accounts.Video
                                      # Add this

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
#    |> validate_required([:name, :email, :bio])
#    |> validate_required([:name, :email, :bio, :number_of_pets])
  end

#  def changeset(model, params \\ %{}) do
#    model
#    |> cast(params, [:name, :email] ++ coherence_fields)  # Add this
#    |> validate_required([:name, :email])
#    |> validate_format(:email, ~r/@/)
#    |> validate_coherence(params)                         # Add this
#  end
#
#  def changeset(model, params, :password) do
#    model
#    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
#    |> validate_coherence_password_reset(params)
#  end

end
