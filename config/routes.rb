Rails.application.routes.draw do

  root 'principal#index'

  get 'principal/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
