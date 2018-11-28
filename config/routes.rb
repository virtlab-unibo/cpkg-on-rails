Rails.application.routes.draw do
  resources :degrees do
    resources :courses
  end

  resources :courses  do
    resources :vlab_packages do
      resources :changelogs
    end
  end

  get "packages/:id/download", controller: "vlab_packages", action: "download", as: 'vlab_package_download'

  resources :users 

  resources :packages do
    get :search, on: :collection
    get :autocomplete_package_name, on: :collection
  end

  resources :vlab_packages do
    resources :documents
    resources :changelogs
    put :depend, on: :member
    put :undepend, on: :member
  end

  resources :documents
  resources :changelogs
  resources :archives do
    get "sync", on: :member
  end
  
  namespace :admin do
    root to: "admin#index"
    resources :courses
    resources :invitations
  end

  get "register", controller: "invitations", action: :register, as: 'register'

  # FIXME 
  # could be more precise about the match: ex \d+-\w+-\d+ for 8014-so-2013
  get ':id', controller: "vlab_packages", action: "show", constraints: { id: /\d+(-\w+)+/ }


  root to: 'degrees#index'
end
