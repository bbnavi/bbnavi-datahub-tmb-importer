Rails.application.routes.draw do
  resources :resources, only: [:index]
  resources :community_records, only: [:index, :show] do
    collection do
      get :import
      get :send_data
    end
    member do
      get :send_single_data
    end
  end
  match "oauth/confirm_access", to: "oauth#confirm_access", via: [:get, :post]
  match "/background" => BetterDelayedJobWeb, anchor: false, via: [:get, :post]
  get "/import_poi", to: "application#import_poi"

  root to: 'resources#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
