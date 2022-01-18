Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      resources :products do
        resources :shipping_products
      end
      resources :shipments do
        resources :shipping_products
      end
      resources :shipping_products
    end
  end
end
