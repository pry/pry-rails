# Description

Avoid repeating yourself, use pry-rails instead of copying the initializer to every rails project.
This is a small gem which causes `rails console` to open [pry](http://pry.github.com/). It therefore depends on *pry*.

# Prerequisites

- A Rails >= 3.0 Application

# Installation

Add this line to your gemfile:

	gem 'pry-rails', :group => :development

`bundle install` and enjoy pry.

# Usage

```
$ rails console
[1] pry(main)> show-routes
     pokemon POST   /pokemon(.:format)      pokemons#create
 new_pokemon GET    /pokemon/new(.:format)  pokemons#new
edit_pokemon GET    /pokemon/edit(.:format) pokemons#edit
             GET    /pokemon(.:format)      pokemons#show
             PUT    /pokemon(.:format)      pokemons#update
             DELETE /pokemon(.:format)      pokemons#destroy
        beer POST   /beer(.:format)         beers#create
    new_beer GET    /beer/new(.:format)     beers#new
   edit_beer GET    /beer/edit(.:format)    beers#edit
             GET    /beer(.:format)         beers#show
             PUT    /beer(.:format)         beers#update
             DELETE /beer(.:format)         beers#destroy
[2] pry(main)> show-routes --grep beer
        beer POST   /beer(.:format)         beers#create
    new_beer GET    /beer/new(.:format)     beers#new
   edit_beer GET    /beer/edit(.:format)    beers#edit
             GET    /beer(.:format)         beers#show
             PUT    /beer(.:format)         beers#update
             DELETE /beer(.:format)         beers#destroy
[3] pry(main)> show-routes --grep new
 new_pokemon GET    /pokemon/new(.:format)  pokemons#new
    new_beer GET    /beer/new(.:format)     beers#new
```

# Alternative

If you want to enable pry everywhere, make sure to check out [pry everywhere](http://lucapette.com/pry/pry-everywhere/).
