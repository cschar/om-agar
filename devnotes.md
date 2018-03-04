


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


## asset pipeline 

cd assets
node_modules/brunch/bin/brunch build


## check out TALON for admin dashboard
https://github.com/talonframework/talon


## creating json resource

mix phx.gen.json Accounts Orb orbs name:string


### phoenix installers... 3 letters words for 1.3
phoenix new (1.2!!!)
phx.new  (1.3) 
coherence.install --full  (1.2!!)
coh.install --full (1.3)


##erlang modules in eelixir

:math.pow(2,6)  2^6