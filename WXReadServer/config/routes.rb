Rails.application.routes.draw do
  devise_for :users
  mount WxRead::API  => '/'
  mount ApiUser::API => '/'
end
