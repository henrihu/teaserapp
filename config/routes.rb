Rails.application.routes.draw do
  
  root :to => 'admin/users#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  post 'login' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  post 'register' => 'users#create'
  post 'all_genres' => 'users#all_genres'
  post 'genre_video' => 'users#genre_video'
  post 'facebook_login' => 'users#facebook_login'
  post 'starred_videos' => 'users#starred_videos'
  post 'random_video' => 'users#random_video'
  post 'paid_version' => 'users#paid_version'
  post 'get_starred_videos' => 'users#get_starred_videos'
end
