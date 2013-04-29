MscApp::Application.routes.draw do

  root to: "static_pages#home"

  # Admin
  match '/overwatch/users' => 'users#index', via: :get, as: :all_users
  
  # match 'overwatch/users/new_from_email' => 'users#new_from_email',
  # via: :get, as: :new_from_email
  # match 'overwatch/users/new_from_email' => 'users#create_from_email',
  # via: :post, as: :new_from_email

  # account inactive
  match '/accountinactive' => 'users#account_inactive',
    via: :get, as: :account_inactive

  # Sessions
  resources :sessions


  # Users
  resources :users, except: [:new, :create] do
  end


  # Enquiries
  resources :enquiries, except: [:new, :create, :edit, :update]

  match '/enquire/:user_id' => 'enquiries#new', via: :get, as: :new_enquiry
  match '/enquire/:user_id/submit' => 'enquiries#create', via: :post, 
                                        as: :enquire


  # Events
  match '/agenda',  to: 'events#show_agenda'
  match '/week',    to: 'events#show_week'
  match '/month',   to: 'events#show_month'

  match '/calendar(/:year(/:month))' => 'events#show_month', as: :calendar,
          constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  resources :events, only: [:show, :new, :create, :edit, :update, :destroy]


  # Clients, Contacts and Projects
  resources :clients do
    resources :contacts, only: [:new, :create]
    resources :projects, only: [:new, :create]
  end


  # Contacts
  resources :contacts, except: [:index, :show]


  # Projects and Phases
  resources :projects, except: [:new, :create] do
    resources :phases, only: [:new, :create]
  end
  match '/project/:id/done' => 'projects#mark_as_done', 
          via: :post, as: :project_done
  match 'projects/:id/unarchive' => 'projects#un_archive',
          via: :post, as: :project_unarchive

  match '/clientview/:id(/:year(/:month))' => 'projects#client_view', 
        as: :project_client_view,
        constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  match '/done_projects' => 'projects#done_projects',
        as: :done_projects

  match '/project/:id/reorderphases' => 'projects#reorder_phases',
        via: :get,
        as: :project_reorder_phases


  # Phases and Tasks
  resources :phases, except: [:new, :create, :index] do
    resources :tasks, only: [:new, :create]
  end
  match '/phase/:id/done' => 'phases#mark_as_done', via: :post, as: :phase_done
  
  match '/phase/:id/movedown' => 'phases#move_down', 
  via: :get, as: :phase_move_down
  match '/phase/:id/moveup' => 'phases#move_up', 
  via: :get, as: :phase_move_up

  # Tasks
  resources :tasks, only: [:show, :edit, :update, :destroy] do
    resources :events, only: [:new]
  end
  match '/task/:id/done' => 'tasks#mark_as_done', via: :post, as: :task_done


  # Subscription Plans
  match '/subscribe', to: 'static_pages#plans', as: :plans

  # Misc
  match '/contact_us', to:'static_pages#contact'
  match '/userguide', to: 'static_pages#user_guide', as: :user_guide

  
  get     'login',    to: 'sessions#new',     as: 'login'
  delete  'logout',   to: 'sessions#destroy', as: 'logout'
  # get     'signup',   to: 'users#new',        as: 'signup'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
