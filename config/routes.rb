MDme::Application.routes.draw do

  require 'domains'

  #constraints(Subdomain) do
   # constraints subdomain: 'doctors' do
    #    root 'doctors#home'
    #end
  #end

  match '/', to: 'doctors#home', via: 'get', constraints: { subdomain: 'doctors' }

  #constraints(RootDomain) do
    #constraints subdomain: false do
    root 'static_pages#home', constraints: { subdomain: 'www' }
    match '/signup',    to: 'patients#new',           via: 'get',    constraints: { subdomain: false }
    match '/help',      to: 'static_pages#help',      via: 'get',    constraints: { subdomain: false }
    match '/about',     to: 'static_pages#about',     via: 'get',    constraints: { subdomain: false }
    match '/contact',   to: 'static_pages#contact',   via: 'get',    constraints: { subdomain: false }
    match '/signin',    to: 'sessions#new',           via: 'get',    constraints: { subdomain: false }
    match '/signout',   to: 'sessions#destroy',       via: 'delete', constraints: { subdomain: false }

    resources :patients
    resources :sessions, only: [:new, :create, :destroy]
   # end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
