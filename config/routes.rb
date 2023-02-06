# frozen_string_literal: true

Rails.application.routes.draw do
  get "/", to: redirect("/admin")

  devise_for :customers,
             controllers: {
               sessions: "customers/sessions",
               registrations: "customers/registrations",
               passwords: "customers/passwords",
               confirmations: "customers/confirmations",
               unlocks: "customers/unlocks",
             }

  devise_for :admin_users,
             path: "",
             controllers: {
               sessions: "active_admin/devise/sessions",
               passwords: "active_admin/devise/passwords",
               registrations: "shops/registrations",
             }
  ActiveAdmin.routes(self)

  resources :products, only: %i[index show] do
    resources :votes, shallow: true, only: %i[create update destroy]
    resources :comments, shallow: true, only: %i[index create]
  end
  get "categories" => "products#categories"
  # get "recommended" => "products#recommend"
  get "search" => "products#search"

  resources :carts, only: %i[index destroy] do
    resources :cart_items, shallow: true, except: %i[new edit create show]
    resources :orders, only: %[create]
  end
  delete "carts" => "carts#clear" # delete all carts

  resources :cart_items, only: %[create]
  resources :orders, only: %i[index show]

  # CUSTOMER
  post "feedbacks" => "feedback#create"
  get "customer" => "profile#show"
end
