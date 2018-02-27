defmodule Mix.Tasks.Gen.Users do
  use Mix.Task

  alias Om.{Repo, User}

  @users ["ana", "aba"]

  def run(_args) do
    Mix.shell.info "Generating Users..."
#    u = %User{name: "test"}
#    Repo.insert(u)

#    Enum.each(@users, fn name ->
#
#      email = name <> "@example.com"
#      u = %User{name: name, email: email}
#
#      Repo.insert(u)
#    end)

  end

  # We can define other functions as needed here.
end