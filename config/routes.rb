Rails.application.routes.draw do
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

  devise_for :employees

  root "home#index"

  # Routes for the Organization resource:

  # CREATE
  post("/insert_organization", { :controller => "organizations", :action => "create" })
          
  # READ
  get("/organizations", { :controller => "organizations", :action => "index" })
  
  get("/organizations/:path_id", { :controller => "organizations", :action => "show" })
  
  # UPDATE
  
  post("/modify_organization/:path_id", { :controller => "organizations", :action => "update" })
  
  # DELETE
  get("/delete_organization/:path_id", { :controller => "organizations", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
