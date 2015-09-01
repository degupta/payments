Payments::Application.routes.draw do
  root to: 'login#index'
  get  'login', to: 'login#index'
  post 'login', to: 'login#login'
  get  'logout', to: 'login#logout'
  get  'forgot_password', to: 'login#forgot_password', as: 'forgot_password'
  post 'forgot_password', to: 'login#forgot_password', as: 'forgot_password_reset'

  resources :companies
end
