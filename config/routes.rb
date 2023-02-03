Rails.application.routes.draw do
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  namespace :public do
    get "home/about" => "homes#about"
    resources :books, only:[:index, :edit, :show, :create, :destroy, :update]
    resources :customers, only:[:index, :edit, :show, :update]
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
