# frozen_string_literal: true

# rubocop:disable Lint/Debugger
TestApp.routes.draw do
  resource :pokemon, :beer
  get 'exit' => proc { exit! }
  get 'pry' => proc {
                 binding.pry
                 [200, {}, ['']]
               }
end
# rubocop:enable Lint/Debugger
