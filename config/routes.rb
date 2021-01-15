Rails.application.routes.draw do

#          new_user_session GET      /users/saml/sign_in(.:format)                       devise/saml_sessions#new
#              user_session POST     /users/saml/auth(.:format)                          devise/saml_sessions#create
#      destroy_user_session DELETE   /users/sign_out(.:format)                           devise/saml_sessions#destroy
#     metadata_user_session GET      /users/saml/metadata(.:format)                      devise/saml_sessions#metadata
# idp_sign_out_user_session GET|POST /users/saml/idp_sign_out(.:format)                  devise/saml_sessions#idp_sign_out


  devise_for :users, controllers: {
    saml_sessions: 'users/saml_sessions'
  }

  get '/api_teryt/items',               to: 'api_teryt#items'
  get '/api_teryt/items/:id',           to: 'api_teryt#item_show'
  get '/api_teryt/provinces',           to: 'api_teryt#provinces'
  get '/api_teryt/provinces/:id',       to: 'api_teryt#province_show'
  get '/api_teryt/province_districts',  to: 'api_teryt#province_districts'
  get '/api_teryt/districts/:id',       to: 'api_teryt#district_show'
  get '/api_teryt/district_communes',   to: 'api_teryt#district_communes'
  get '/api_teryt/communes/:id',        to: 'api_teryt#commune_show'

  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do

    resources :api_uke_regulations, only: [:index]

    resources :works, only: [:index] do
      post 'datatables_index', on: :collection # for User
      post 'datatables_index_trackable', on: :collection # for Trackable
      post 'datatables_index_user', on: :collection # for User
    end

    resources :versions, only: [:index] do
      post 'datatables_index', on: :collection # for User
      post 'datatables_index_trackable', on: :collection # for Trackable
      post 'datatables_index_user', on: :collection # for User
    end

    resources :users do
      get 'select2_index', on: :collection
      post 'datatables_index', on: :collection
      get 'datatables_index_for_role', on: :collection # Displays users for showed role
    end

    resources :roles do
      post 'datatables_index', on: :collection
      get 'datatables_index_for_user', on: :collection # Displays roles for showed user
      resources :users, only: [:create, :destroy], controller: 'roles/users'
    end    

    resources :organizations do
      get 'select2_index', on: :collection
      post 'datatables_index', on: :collection
      get 'ajax_load_proposals', on: :member
      get 'ajax_load_registers', on: :member
    end    

    scope ':service_type', constraints: { service_type: /[jpt]/ } do

      resources :proposal_candidates do
        resources :wizard, only: [:show, :update], controller: 'proposal_candidates/wizard_steps'
      end    

      resources :proposals do
        post 'datatables_index', on: :collection
        get 'edit_to_approved', on: :member
        patch 'update_to_approved', on: :member
        get 'edit_to_rejected', on: :member
        patch 'update_to_rejected', on: :member
        get 'edit_to_annuled', on: :member
        patch 'update_to_annuled', on: :member
      end    

      resources :registers do
        get 'select2_index', on: :collection
        post 'datatables_index', on: :collection
        get 'ajax_load_proposals', on: :member
      end    
    end    

    get 'datatables/lang'
    get 'static_pages/home'

    root to: 'static_pages#home'
	end

  root to: redirect("/#{I18n.default_locale}", status: 302), as: :redirected_root
  # get "/*path", to: redirect("/#{I18n.default_locale}/%{path}", status: 302),
  #               constraints: { path: /(?!(#{I18n.available_locales.join("|")})\/).*/ },
  #               format: false

      # resources :apidocs, only: [:index]
      resources :swagger, only: [:index]

  namespace :api, defaults: { format: :json } do
    require 'api_constraints'
    namespace :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :apidocs, only: [:index]
      # resources :swagger, only: [:index]
      
      get :token, controller: 'base_api'
      resources :organizations, only: [] do
        post 'cbo_new_data_service', on: :collection
      end

      namespace :dictionary do
        resources :address_ext_types, only: [:index, :show]
        resources :address_types, only: [:index, :show]
        resources :attachment_types, only: [:index, :show]
        resources :identifier_types, only: [:index, :show]
        resources :jst_legal_form_types, only: [:index, :show]
        resources :legal_form_types, only: [:index, :show]
        resources :network_types, only: [:index, :show]
        resources :proposal_statuses, only: [:index, :show]
        resources :proposal_types, only: [:index, :show]
        resources :register_statuses, only: [:index, :show]
        resources :representative_types, only: [:index, :show]
        resources :service_types, only: [:index, :show]
      end

      scope ':service_type', constraints: { service_type: /[jpt]/ } do
        resources :registers, param: :id_or_number, only: [:index, :show]
      end

    end

    namespace :v2 do
    end
  end
end
