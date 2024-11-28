Rails.application.routes.draw do
  devise_for :employees, skip: [:registrations]
  
  as :employee do
    get "employees/sign_up", to: redirect("/"), as: :new_employee_registration
  end

  root "organizations#index"

  resources :employees do
    resources :responsibilities, only: [:create, :edit, :update, :destroy]
    
    collection do
      post :upload_csv
    end

    member do
      get :edit_organization
      patch :update_organization
      get :edit_manager
      patch :update_manager
    end
  end

  resources :organizations do
    resources :employees, only: [:index, :new, :create]

    collection do
      post :upload_csv
    end
  end

  resources :responsibilities, only: [:create, :edit, :update, :destroy]

  get "search/results", to: "search#results", as: :search_results
end
