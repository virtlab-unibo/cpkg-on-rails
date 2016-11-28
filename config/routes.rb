Rails.application.routes.draw do

  resources :degrees do
    resources :courses
  end

  resources :courses  do
    resources :packages do
      resources :changelogs
    end
  end

  get "packages/:id/download", controller: "packages", action: "download", as: 'packages_download'

  resources :users 

  resources :packages do
    resources :documents
    resources :changelogs
    get :autocomplete_package_name, on: :collection
    get :search, on: :collection, as:'search'
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

  # namespace :guest do
  #   resources :courses do
  #     resources :packages
  #   end
  #   resources :packages
  # end

  # FIXME 
  # could be more precise about the match: ex \d+-\w+-\d+ for 8014-so-2013
  get ':id', controller: "packages", action: "show", module: "guest", constraints: { id: /\d+-\w+-\d+/ }

  root to: 'degrees#index'
end
