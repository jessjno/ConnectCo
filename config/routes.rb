Rails.application.routes.draw do
  devise_for :employees, skip: [:registrations]
  resources :employees, only: [:show, :edit, :update, :new, :create, :destroy]
  root "organizations#index"

  resources :organizations, only: %i[index show new create edit update destroy]
  resources :organizations do
    resources :employees, only: [:create, :destroy]
  end

  resources :employees, only: [:show] do
    member do
      get 'edit_responsibility/:id', to: 'employees#edit_responsibility', as: 'edit_responsibility'
      patch 'update_responsibility/:id', to: 'employees#update_responsibility', as: 'update_responsibility'
    end
  end

  # Routes for the Member resource:
  # CREATE
  post("/insert_member", { :controller => "members", :action => "create" })
  # READ
  get("/members", { :controller => "members", :action => "index" })
  get("/members/:path_id", { :controller => "members", :action => "show" })
  # UPDATE
  post("/modify_member/:path_id", { :controller => "members", :action => "update" })
  # DELETE
  get("/delete_member/:path_id", { :controller => "members", :action => "destroy" })

  #------------------------------

  # Routes for the Responsibility resource:
  # CREATE
  post("/insert_responsibility", { :controller => "responsibilities", :action => "create" })
  # READ
  get("/responsibilities", { :controller => "responsibilities", :action => "index" })
  get("/responsibilities/:path_id", { :controller => "responsibilities", :action => "show" })
  # UPDATE
  post("/modify_responsibility/:path_id", { :controller => "responsibilities", :action => "update" })
  # DELETE
  get("/delete_responsibility/:path_id", { :controller => "responsibilities", :action => "destroy" })
  #------------------------------

  # Routes for the Organization resource:
  # CREATE
  post("/insert_organization", { :controller => "organizations", :action => "create" })
  # READ
  get("/organizations", { :controller => "organizations", :action => "index" })
  get("/organizations/:id", { :controller => "organizations", :action => "show" })
  # UPDATE
  post("/modify_organization/:path_id", { :controller => "organizations", :action => "update" })
  # DELETE
  get("/delete_organization/:path_id", { :controller => "organizations", :action => "destroy" })
end
