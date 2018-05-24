# Om agar

Graft on codingtrain 33.2 agar sketch into a phoenix web app.
Adds multiplayer.


# Running Locally

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


### stuff
- heartbeat periodcally.ex fires via application.ex worker


### seeding data
mix run priv/repo/seeds.exs

### Running mix tasks 
 (lib/mix/tasks folder)
mix hello.greeting



### fresh push to heroku
https://hexdocs.pm/phoenix/heroku.html

```
heroku pg:reset DATABASE  #optional

heroku run "POOL_SIZE=2 mix ecto.migrate"
```