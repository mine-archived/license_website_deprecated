Rails.application.routes.draw do
  get 'welcome/index'



  resources :releases do
    resources :repos do
      resources :packs
    end
    resources :products do
      resources :repos do
        resources :packs
      end
      resources :packs
    end
    resources :cases
  end

  resources :packlist

  resources :ubuntu

  post '/api/v1/repo/parse_dependency' => 'repos#parse_dependency'
  post '/api/v1/repo/enqueue_all_repo' => 'repos#enqueue_all_repo'
  get '/ratio' => 'repos#compute_status_ratio'

  post '/ubuntu/insert_packs' => 'ubuntu#insert_packs'
  get '/api/v1/repo/complete_ratio' => 'repos#restful_api_complete_ratio'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
