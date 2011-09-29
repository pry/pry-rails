# Description

This is a small gem which causes `rails console` to open [pry](http://pry.github.com/). It therefore depends on *pry* and *pry-doc*.

# Prerequisites

- A Rails >= 3.0 Application

# Installation

Avoid repeating yourself, use pry-rails instead of copying the initializer to every rails project. Add this line to your gemfile:

	gem 'pry-rails', :group => :development

`bundle install` and enjoy pry.

# Alternative

If you want to enable pry everywhere, make sure to check out [pry everywhere](http://lucapette.com/pry/pry-everywhere/).
