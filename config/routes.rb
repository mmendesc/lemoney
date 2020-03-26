Rails.application.routes.draw do

  namespace :admin do
    resources :offers do
      member do
        patch :enable
        patch :disable
      end
    end

    root to: 'offers#index'
  end

  resources :offers

  root to: 'offers#index'
end
