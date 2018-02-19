Rails.application.routes.draw do
  
  resources :posts
  root 'posts#index'
  

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end
