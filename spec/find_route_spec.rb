# frozen_string_literal: true

require 'spec_helper'

describe 'find-route' do
  before do
    routes = Rails.application.routes
    routes.draw do
      namespace :admin do
        resources :users
        resources :images
      end
    end
    routes.finalize!
  end

  it 'returns the route for a single action' do
    output = mock_pry('find-route Admin::UsersController#show', 'exit-all')
    _(output).must_match(/show GET/)
    _(output).wont_match(/index GET/)
  end

  it 'returns all the routes for a controller' do
    output = mock_pry('find-route Admin::UsersController', 'exit-all')
    _(output).must_match(/index GET/)
    _(output).must_match(/show GET/)
    _(output).must_match(/new GET/)
    _(output).must_match(/edit GET/)
    _(output).must_match(/update (PATCH|PUT)/)
    _(output).must_match(/update PUT/)
    _(output).must_match(/destroy DELETE/)
  end

  it 'returns all routes for controllers under a namespace' do
    output = mock_pry('find-route Admin', 'exit-all')
    _(output).must_match(/Routes for Admin::UsersController/)
    _(output).must_match(/Routes for Admin::ImagesController/)
  end

  it 'returns no routes found when controller is not recognized' do
    output = mock_pry('find-route Foo', 'exit-all')
    _(output).must_match(/No routes found/)
  end
end
