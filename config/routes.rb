Rails.application.routes.draw do
  root "organizations#index"
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

  devise_for :employees

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
end
