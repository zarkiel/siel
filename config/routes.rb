Siel::Engine.routes.draw do
	root :to => 'index#index'
    
    # ENVIRONMENT
    get 'environment' => 'environment#index'
    
    # CONTROLLERS
    get 'controllers' => 'controllers#index'
    get 'controllers/create' => 'controllers#create'
    post 'controllers/create' => 'controllers#do_create'
    post 'controllers/delete' => 'controllers#delete'
    
    # MODELS
    get 'models' => 'models#index'
    get 'models/create' => 'models#create'
    post 'models/create' => 'models#do_create'
    
    get 'models/relationships/:model' => 'models#relationships'
    post 'models/relationships' => 'models#do_relationships'
    
    get 'models/edit/:model' => 'models#edit'
	post 'models/edit' => 'models#do_edit'
    
    get 'models/raw_edit' => 'models#raw_edit'
    post 'models/raw_edit' => 'models#do_raw_edit'
    post 'models/delete' => 'models#delete'
    
    # MIGRATIONS
    get 'migrations' => 'migrations#index'
    get 'migrations/create' => 'migrations#create'
    post 'migrations/create' => 'migrations#do_create'
    
=begin
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	match 'models/delete' => 'models#delete'
=end

end
