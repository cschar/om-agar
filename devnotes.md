


```
alias Om.User
params = %{name: "Joe Example", email: "joe@example.com", bio: "An example to all", number_of_pets: 5, random_key: "random value"}
changeset = User.changeset(%User{}, params)
```


:observer.start

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

# generators

mix phx.gen.html Accounts Video videos user_id:references:users url:string title:string description:text

# Then add in model refernece lines
```
# in user schema
has_many :videos, Om.Accounts.Video

# in video schema
belongs_to :user, Om.User

```

then in iex, make a reference
```
alias Om.Repo
alias Om.User
import Ecto.Query
u = Repo.get(User,1) # get first user
u.videos
#Ecto.Association.NotLoaded<association :videos is not loaded>
u = Repo.preload(u, :videos)
[]


attrs = %{title: "hi", description: "says hi", url: "example.com"}
## will add user_id corresponding to u
video = Ecto.build_assoc(u, :videos, attrs)
video = Repo.insert!(video)

```

Preload is great for bundling data. Other times we want to fetch the videos
associated with a user, without storing them in the user struct, like this:
```
iex> query = Ecto.assoc(user, :videos)
#Ecto.Query<...>

iex> Repo.all(query)
[%Om.Video{...}]
```

## creating json resource

mix phx.gen.json Accounts Orb orbs name:string


### phoenix installers... 3 letters words for 1.3
phoenix new (1.2!!!)
phx.new  (1.3) 
coherence.install --full  (1.2!!)
coh.install --full (1.3)




##erlang modules in eelixir

:math.pow(2,6)  2^6