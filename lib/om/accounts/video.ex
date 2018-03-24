defmodule Om.Accounts.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Om.Accounts.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string


    # sets up a belongs_to association, defining a
    #:user_id field of type :integer and an association field.
    # Our migration defines a :user_id foreign key.
    # Ecto will use these elements to build the right association between our models.
    belongs_to :user, Om.User
#    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description])
    |> validate_required([:url, :title, :description])
  end
end
