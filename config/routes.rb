# rubocop:disable Metrics/BlockLength
# FIXME: block length max is set to 25
Rails.application.routes.draw do
  mount Rswag::Ui::Engine  => '/docs'
  mount Rswag::Api::Engine => '/docs'

  root to: redirect('https://web.tdl.app')

  # Default to json for all requests
  defaults format: :json do
    # Sync Ordering
    patch 'lists/sync-ordering' => 'lists#sync_ordering'
    patch 'tags/sync-ordering' => 'tags#sync_ordering'
    patch 'tasks/sync-ordering' => 'tasks#sync_ordering'
    # Bulk updates
    patch 'tasks/bulk' => 'tasks#bulk'

    # Server health check
    get 'health' => 'health#health'

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    post 'login'    => 'user_sessions#create'
    delete 'logout' => 'user_sessions#destroy'

    # MFA
    post 'verify/token' => 'user_sessions#verify_auth_token'
    post 'verify/app' => 'user_sessions#verify_authy_app'

    # Access requests
    post 'access-request' => 'access_requests#create'

    # Settings (merge with users controller?)
    get 'username' => 'settings#username'
    get 'time-zones' => 'settings#time_zones'

    # TODO: Nest inside resources :users
    get 'time-zone' => 'users#time_zone'
    patch 'time-zone' => 'users#update_time_zone'

    post 'tasks/clear-completed' => 'tasks#clear_completed'

    resources :lists
    resources :tags

    resources :tasks do
      patch 'mark-complete' => 'tasks#mark_complete'
      patch 'mark-incomplete' => 'tasks#mark_incomplete'
      patch 'tags' => 'tasks#update_tags'
      patch 'list' => 'tasks#update_list'
      patch 'pre' => 'tasks#add_prerequisite'
      patch 'post' => 'tasks#add_postrequisite'
      delete 'pre/:pre_task_id' => 'tasks#remove_prerequisite'
      delete 'post/:post_task_id' => 'tasks#remove_postrequisite'
    end

    resources :rules

    get '*unmatched_route', to: 'application#not_found'
    post '*unmatched_route', to: 'application#not_found'
    patch '*unmatched_route', to: 'application#not_found'
    delete '*unmatched_route', to: 'application#not_found'
  end
  # rubocop:enable Metrics/BlockLength
end
