

```
alias Om.User
params = %{name: "Joe Example", email: "joe@example.com", bio: "An example to all", number_of_pets: 5, random_key: "random value"}
changeset = User.changeset(%User{}, params)
```

alias Om.{Repo, User}
Repo.insert(%User{email: "user1@example.com"})
Repo.all(User)

import Ecto.Query
Repo.all(from u in User, select: u.email)

