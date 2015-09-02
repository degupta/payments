Payments::Application.routes.draw do
  root to: 'login#index'
  get  'login', to: 'login#index'
  post 'login', to: 'login#login'
  get  'logout', to: 'login#logout'
  get  'forgot_password', to: 'login#forgot_password', as: 'forgot_password'
  post 'forgot_password', to: 'login#forgot_password', as: 'forgot_password_reset'

  resources :companies do
    post 'add_user', to: 'companies#add_user', as: 'add_user'
    get  'pending_reminders', to: 'companies#pending_reminders', as: 'pending_reminders'

    resources 'reminders' do
      post 'sent_message', to: 'reminders#sent_message', as: 'sent_message'
    end
  end
end
