# rubocop:disable Metrics/BlockLength
# FIXME: block length max is set to 25
Rails.application.routes.draw do
  mount Rswag::Ui::Engine  => '/docs'
  mount Rswag::Api::Engine => '/docs'

  root to: redirect('https://web.tdl.app')

  # Default to json for all requests
  defaults format: :json do
    ###################
    ## Meta Requests ##
    ###################

    # FIXME: Cloudflare might be caching this, defeating the purpose.
    # Server Health Status
    get 'health' => 'health#health'
    # List of available Time Zones
    get 'time-zones' => 'time_zones#index'
    # List of available Locales
    get 'locales' => 'locales#index'

    ###################
    ## Sync Ordering ##
    ###################

    patch 'projects/sync-ordering' => 'projects#sync_ordering'
    patch 'next-actions/sync-ordering' => 'next_actions#sync_ordering'
    patch 'waiting-fors/sync-ordering' => 'waiting_fors#sync_ordering'
    patch 'contexts/sync-ordering' => 'contexts#sync_ordering'
    patch 'subtasks/sync-ordering' => 'subtasks#sync_ordering'

    #############
    # Sessions ##
    #############

    post 'login'    => 'user_sessions#create'
    delete 'logout' => 'user_sessions#destroy'
    # MFA (to be implemented)
    post 'verify/token' => 'user_sessions#verify_auth_token'
    post 'verify/app' => 'user_sessions#verify_authy_app'

    #####################
    ## Access requests ##
    #####################

    post 'access-request' => 'access_requests#create'

    ##########
    ## CRUD ##
    ##########

    resources :users, only: [:show, :update]

    resources :projects
    resources :contexts

    resources :inbox_items
    resources :next_actions
    resources :waiting_fors

    # TODO: How should this interact API-wise? Nest under next actions?
    resources :subtasks

    # Similarly, these are a little weird in nature
    resources :project_relationships
    resources :next_action_relationships

    # FIXME: Is there a way to match any HTTP method and return 404?
    get '*unmatched_route', to: 'application#not_found'
    post '*unmatched_route', to: 'application#not_found'
    patch '*unmatched_route', to: 'application#not_found'
    delete '*unmatched_route', to: 'application#not_found'
  end
  # rubocop:enable Metrics/BlockLength
end
