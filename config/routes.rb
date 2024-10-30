Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  get "about", to: "home#about", as: "about"
  get "errors/not_found"
  get "errors/internal_server_error"
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  resources :carts, only: [ :index ]

  resources :orders, only: [ :index, :create, :show, :destroy ] do
    collection do
      get "order_requests", to: "orders#order_requests", as: "order_requests"
      get "checkout", to: "orders#checkout", as: "checkout"
      post "save_address", to: "orders#save_address", as: "save_address"
      get "payment", to: "orders#payment_page", as: "payment"
    end
    member do
      post "dispatch", to: "orders#approve", as: "dispatch"
      post "cancel", to: "orders#seller_cancel", as: "seller_cancel"
    end
  end

  resources :line_items, only: [ :create, :update, :destroy ]

  resources :users, only: [ :show, :edit, :update ]

  resources :products, only: [ :new, :index, :show, :destroy, :create, :update, :edit ] do
    collection do
      get "search_products", to: "products#search", as: "search"
    end
  end

  resources :sellers, only: [ :index ]

  resources :addresses, only: [ :index, :edit, :create, :update, :destroy, :show, :new ]

  resources :admins, only: [ :index ]

  root "products#index"
end
