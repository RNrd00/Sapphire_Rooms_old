Rails.application.routes.draw do
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  namespace :public do
    get "home/about" => "homes#about"
    get "/search", to: "searches#search"
    resources :books, only: %i[index edit show create destroy update] do
      resources :book_comments, only: %i[create destroy]
      resource :favorites, only: %i[create destroy]
    end
    resources :customers, only: %i[index edit show update] do
      resource :relationships, only: %i[create destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      get "daily_posts" => "customers#daily_posts"
      patch :release
      patch :nonrelease
      get :unsubscribe
      patch :withdrawal
      member do
        get :likes
      end
    end
    resources :groups, only: %i[new index show create edit update destroy] do
      resource :group_customers, only: %i[create destroy]
      resources :event_notices, only: %i[new create]
      get "event_notices" => "event_notices#sent"
    end
    resources :chats, only: %i[show create]
    resources :ratings, only: %i[index create destroy]
    resources :notifications, only: [:index]
    resources :dictionaries, only: [:index] do
      collection do
        get :sns
        get :room
        get :user
        get :chat
      end
    end
  end

  scope module: :public do
    root to: "homes#top"
  end

  devise_for :admin, skip: %i[registrations passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_scope :customer do
    post "customer/guest_sign_in", to: "customers/sessions#guest_sign_in"
  end
end
