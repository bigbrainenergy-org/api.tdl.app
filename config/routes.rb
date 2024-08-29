# FIXME: block length max is set to 25
# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount Rswag::Ui::Engine  => '/docs'
  mount Rswag::Api::Engine => '/docs'

  root to: redirect(Rails.configuration.x.frontend_redirect_url.to_s)

  # Default to json for all requests
  defaults format: :json do
    ###################
    ## Meta Requests ##
    ###################

    # FIXME: Cloudflare might be caching this, defeating the purpose.
    # Server Health Status
    get 'health' => 'meta#health'
    # List of available Time Zones
    get 'time-zones' => 'meta#time_zones'
    # List of available Locales
    get 'locales' => 'meta#locales'

    ##########
    ## Bulk ##
    ##########

    patch 'tasks/bulk-all' => 'tasks#bulk_all_same_vales'
    patch 'tasks/bulk-each' => 'tasks#bulk_each_different_values'

    # patch 'waiting-fors/bulk-all' => 'waiting_fors#bulk_all_same_vales'
    # patch 'waiting-fors/bulk-each' =>
    #   'waiting_fors#bulk_each_different_values'

    # patch 'projects/bulk-all' => 'projects#bulk_all_same_vales'
    # patch 'projects/bulk-each' => 'projects#bulk_each_different_values'

    # patch 'contexts/bulk-all' => 'contexts#bulk_all_same_vales'
    # patch 'contexts/bulk-each' => 'contexts#bulk_each_different_values'

    patch 'subtasks/bulk-all' => 'subtasks#bulk_all_same_vales'
    patch 'subtasks/bulk-each' => 'subtasks#bulk_each_different_values'

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

    ###########################
    ## Change/Reset Password ##
    ###########################

    # FIXME: This should only be able to change the current user's password
    patch 'users/:user_id/change-password' => 'users#change_password'

    ##########
    ## CRUD ##
    ##########

    resources :users, only: [:show, :update]

    # resources :projects
    # resources :contexts

    # resources :inbox_items
    resources :tasks do
      collection do
        get 'bulk'
        patch 'bulk'
        post 'bulk'
      end
    end
    resources :lists
    # resources :waiting_fors

    # TODO: How should this interact API-wise? Nest under tasks?
    resources :subtasks
    resources :statuses

    # Similarly, these are a little weird in nature
    resources :project_relationships
    resources :next_action_relationships
    resources :procedures do
      member do
        post 'reset'
      end
    end

    #########
    ## 404 ##
    #########

    # FIXME: Is there a way to match any HTTP method and return 404?
    get '*unmatched_route', to: 'application#not_found'
    post '*unmatched_route', to: 'application#not_found'
    patch '*unmatched_route', to: 'application#not_found'
    delete '*unmatched_route', to: 'application#not_found'
  end
end
# rubocop:enable Metrics/BlockLength
