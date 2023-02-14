Rails.application.routes.draw do
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  namespace :public do
    get "home/about" => "homes#about"
    get '/search', to: 'searches#search'
    resources :books, only:[:index, :edit, :show, :create, :destroy, :update] do
      resources :book_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    resources :customers, only:[:index, :edit, :show, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      get "daily_posts" => "customers#daily_posts"
      patch :release
      patch :nonrelease
      member do
        get :likes
      end
    end
    resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
      resource :group_customers, only: [:create, :destroy]
      resources :event_notices, only: [:new, :create]
      get "event_notices" => "event_notices#sent"
    end
    resources :chats, only: [:show, :create]
    resources :ratings, only: [:index, :create, :destroy]
  end
  
  scope module: :public do
    root to: "homes#top"
  end

devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

  devise_scope :customer do
    post 'customer/guest_sign_in', to: 'customers/sessions#guest_sign_in'
  end
end
