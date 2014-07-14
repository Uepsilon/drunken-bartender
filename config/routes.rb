Consumo::Application.routes.draw do
  devise_for :users

    root to: "order_items#new"

    namespace :statistics do
      resources :orders do
        collection do
          match 'search' => 'statistics_orders#index', via: [:get, :post]
        end
      end
      resources :popularity do
        collection do
          match 'search' => 'statistics_popularity#search', via: [:get, :post], as: :search  
        end
      end
    end


    resources :orders, via: [:get, :post] do
      collection do
        match 'search' => 'orders#search', via: [:get, :post], as: :search  
      end
    end
    resources :bookings, via: [:get, :post] do
      collection do
        match 'search' => 'bookings#search', via: [:get, :post], as: :search  
      end
    end
    resources :deliveries, via: [:get, :post] do
      collection do
        match 'search' => 'deliveries#search', via: [:get, :post], as: :search  
      end
    end
    resources :products, via: [:get, :post] do
      collection do
        match 'search' => 'products#search', via: [:get, :post], as: :search  
      end
    end
    resources :skus
    resources :categories
    resources :deliveries, except: [:show, :edit, :update]
    resources :users, only: [:index, :edit], via: [:get, :post] do
      collection do
        match 'search' => 'users#search', via: [:get, :post], as: :search  
        patch 'update_password'
      end
    end
    resources :order_items, only: [:new, :create]
end
