Rails.application.routes.draw do
  root 'principal#index'
  post 'calcular', to: 'principal#calcular'
end
