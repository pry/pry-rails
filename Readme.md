	This project is not actively maintained and looking for a maintainer!


# Description
This fork is only made for rails 7 (`rails7` branch) and ruby version >= 2.3.
Other versions have not been tested and it is not known if they work.

Currently, as a test, the new `show-notes` command has been added.

# Prerequisites

- A Rails >= 7.0 Application
- Ruby >= 2.3

# Installation

Add this line to your gemfile:

	gem 'pry-rails', group: :development, git: 'https://github.com/sumskyi/pry-rails', branch: 'rails7'

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

[4] pry(main)> show-models
Beer
  id: integer
  name: string
  type: string
  rating: integer
  ibu: integer
  abv: integer
  created_at: datetime
  updated_at: datetime
  belongs_to hacker
Hacker
  id: integer
  social_ability: integer
  created_at: datetime
  updated_at: datetime
  has_many pokemons
  has_many beers
Pokemon
  id: integer
  name: string
  caught: binary
  species: string
  abilities: string
  created_at: datetime
  updated_at: datetime
  belongs_to hacker
  has_many beers through hacker

[5] [rails_app][development] pry(main)> show-notes
app/controllers/headers_controller.rb:
  * [ 8] [OPTIMIZE] ebc
  * [12] [TODO] use locale from cookies when pesent

config/initializers/rails_admin.rb:
  * [49] [TODO] may be use it?

app/controllers/headers_controller.rb
config/initializers/rails_admin.rb

[6] [rails_app][development] pry(main)> show-notes -w TODO
app/controllers/headers_controller.rb:
  * [12] use locale from cookies when pesent

config/initializers/rails_admin.rb:
  * [49] may be use it?

app/controllers/headers_controller.rb
config/initializers/rails_admin.rb
```

## Custom Rails prompt

If you want to permanently include the current Rails environment and project name
in the Pry prompt, put the following lines in your project's `.pryrc`:

```ruby
Pry.config.prompt = Pry::Prompt[:rails]
```

If `.pryrc` could be loaded without pry-rails being available or installed,
guard against setting `Pry.config.prompt` to `nil`:

```ruby
if Pry::Prompt[:rails]
  Pry.config.prompt = Pry::Prompt[:rails]
end
```

Check out `change-prompt --help` for information about temporarily
changing the prompt for the current Pry session.

## Disabling pry-rails

If pry-rails is included in your application but you would prefer not to use it, you may run the following command to set the appropriate environment variable to disable initialization and fall back to the default IRB console:
```shell
DISABLE_PRY_RAILS=1 rails console
```

Note that you may need to run `spring stop` first.

# Developing and Testing

This repo uses [Roadshow] to generate a [Docker Compose] file for each
supported version of Rails (with a compatible version of Ruby for each one).

To run specs across all versions, you can either [get the Roadshow tool] and
run `roadshow run`, or use Docker Compose directly:

```
$ for fn in scenarios/*.docker-compose.yml; do docker-compose -f $fn run --rm scenario; done

# only rails 7
$ for fn in scenarios/rails70.docker-compose.yml; do sudo docker-compose -f $fn run --rm scenario; done
```

You can also manually run the Rails console and server on each version with
`roadshow run rake console` and `roadshow run rake server`, or run them on a
specific version with, e.g., `roadshow run -s rails40 rake console`.

To update the set of scenarios, edit `scenarios.yml` and run `roadshow
generate`, although the Gemfiles in the `scenarios` directory need to be
maintained manually.

[Roadshow]: https://github.com/rf-/roadshow
[Docker Compose]: https://docs.docker.com/compose/
[get the Roadshow tool]: https://github.com/rf-/roadshow/releases

# Alternative

If you want to enable pry everywhere, make sure to check out
[pry everywhere](http://lucapette.me/pry-everywhere).
