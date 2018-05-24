# Om agar

Graft on codingtrain 33.2 agar sketch into a phoenix web app.
Adds multiplayer.


# Getting up and Running

```
mix deps.get
mix deps.compile
cd assets && npm install

###TODO: Webpack in pheonix 1.4 !!!
node node_modules/brunch/bin/brunch build

# create om_agar_dev table in your local pg database
# defined in config/dev.exs
mix ecto.create
mix ecto.migrate

mix phx.server


#optionally monitor your processes
:observer.start
```

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