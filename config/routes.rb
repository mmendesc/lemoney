Rails.application.routes.draw do

  namespace :admin do
    resources :offers

    root to: 'offers#index'
  end
end
