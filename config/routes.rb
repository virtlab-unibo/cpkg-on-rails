CpkgOnRails::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # remember Notify Channel="front" in shibboleth
  devise_scope :user do 
    get "logins/logout" => 'devise/sessions#destroy', :as => :logout
  end

  get "who_impersonate"    => 'impersonations#who_impersonate',    :as => :who_impersonate
  get "impersonate/:id"    => 'impersonations#impersonate',        :as => :impersonate
  get "stop_impersonating" => 'impersonations#stop_impersonating', :as => :stop_impersonating

  resources :courses  do
    resources :packages do
      resources :changelogs
    end
  end

  get "packages/:id/download", :controller => "packages", :action => "download", :as => 'packages_download'

  resources :packages do
    resources :documents
    resources :changelogs
    get :autocomplete_package_name, :on => :collection
    get :search, :on => :collection, :as =>'search'
    put :depend, :on => :member
    put :undepend, :on => :member
  end

  resources :documents
  resources :changelogs
  
  namespace :admin do
    root :to => "admin#index"
    resources :degrees
    resources :courses
    resources :archives do
      get "sync", :on => :member
    end
    resources :users 
    resources :invitations
  end

  get "register", :controller => "invitations", :action => :register, :as => 'register'

  namespace :guest do
    resources :courses
    resources :packages
  end

  # FIXME 
  # could be more precise about the match: ex \d+-\w+-\d+ for 8014-so-2013
  get ':id', :controller => "packages", :action => "show", :module => "guest"

  root :to => 'courses#index'
end
