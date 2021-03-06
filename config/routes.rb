Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'products#index'

  resources :products, only: [:show, :index] do
    collection do
      get 'search'
    end
  end


  resources :categories, only: [:show]

  resource :cart, only: [:show, :destroy] do
    collection do
      get 'checkout'
    end
  end

  resources :orders, except: [:new, :edit, :update, :destroy] do
    member do
      delete 'cancel'
      post 'pay'
      get 'pay_confirm'
    end
    collection do
      get 'confirm'
    end
  end

 
  namespace :admin do
    root 'products#index'
    resources :products, exctpt: [:show]
    resources :vendors, except: [:show]
    resources :categories, except: [:show] do
      collection do
        put 'sort'
      end
    end
    resources :subscribes, only: [:index, :destroy]
  end

  namespace :api do
    namespace :v1 do
      post 'subscribe', to: 'utils#subscribe'
      post 'cart', to: 'utils#cart'
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
