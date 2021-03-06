require 'api_constraints'

Friendly::Application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  #trick devise to using our registration controller, to respond to json
  devise_for :users, :controllers => {registrations: 'registrations'}  
  # Api definition
  # namespace is used to match directory in controller folder
  # the path backslash / tells rails to look in the root of the subdomain
  namespace :api, defaults: { format: :json }, 
  	constraints: { subdomain: 'api' }, path: '/' do
    
  	#version constraint so version is not in url, it will be in accept headers
  	#default means if version does not exist redirect to version 1
    scope module: :v1,
      constraints: ApiConstraints.new(version: 1, default: true) do
      	resources :users, :only => [:show, :create, :update, :destroy]
      	resources :sessions, :only => [:create, :destroy]  	
    end
  end
end
