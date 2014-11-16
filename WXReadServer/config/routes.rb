Rails.application.routes.draw do
  devise_for :users
  mount Twitter::API => '/'
end
