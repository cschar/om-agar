# Om

Graft on codingtrain 33.2 agar sketch


##reset db
```
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
   ]
``` 
### stuff
- heartbeat periodcally.ex fires via application.ex worker


### seeding data
mix run priv/repo/seeds.exs

### Running mix tasks 
 (lib/mix/tasks folder)
mix hello.greeting



### pushing to heroku
https://hexdocs.pm/phoenix/heroku.html

```
heroku run "POOL_SIZE=2 mix ecto.migrate"
```