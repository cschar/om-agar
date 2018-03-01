# Om

Graft on codingtrain 33.2 agar sketch


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
heroku create
heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir.git
heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git


```