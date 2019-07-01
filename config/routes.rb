Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'reserve/:port_key', to: 'reserves#reserve_bike'
end
