App::Application.routes.draw do
  resource :pokemon, :beer
  get 'pry' => proc { binding.pry; [200, {}, ['']] }
end
