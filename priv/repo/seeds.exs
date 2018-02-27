# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Om.Repo.insert!(%Om.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


users = ["ana", "aba"]
alias Om.{Repo, User}

 Enum.each(users, fn name ->

    email = name <> "@example.com"
    u = %User{name: name, email: email}

    Repo.insert(u)
  end)