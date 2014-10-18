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
  post 'reset_password' => 'passwords#reset_password'
  post 'seen_video' => 'users#seen_video'
  post 'last_video' => 'users#last_video'
  post 'delete_starred_video' => 'users#delete_starred_video'
  post 'erase_seen_videos' => 'users#erase_seen_videos'
  post 'update_profile' => 'passwords#update_profile'

  get 'edit_password/:reset_password_token'   => 'passwords#edit_password', as: :editable
  patch 'update_password/:reset_password_token' => 'passwords#update_password', as: :update_password
end
