class ApplicationController < ActionController::API
  # Load Pundit for Authorization
  include Pundit::Authorization

  # Load Sorcery for Authentication
  authenticates_with_sorcery!

  # TODO: Does JBuilder offer any on_load hooks that can let us do this in
  #       Sorcery?
  helper_method :current_user

  ##############################
  ## Global Rescue Statements ##
  ##############################

  rescue_from ActionController::ParameterMissing, with: :missing_params
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordInvalid, with: :not_processable
  rescue_from 'ActiveRecord::DeleteRestrictionError', with: :not_processable
  rescue_from NotImplementedError, with: :endpoint_not_implemented

  ######################
  ## Global Callbacks ##
  ######################

  before_action :require_login

  ####################
  ## Global Methods ##
  ####################

  # 400
  def missing_params(err)
    render json: { error: err.message }, status: :bad_request
  end

  # Fun fact, 401 is called unauthorized, but is used to indicate
  # unauthenticated errors. 403 is called forbidden, and used for unauthorized
  # errors. Yes, this does indeed irritate me to no end.

  # 401
  def not_authenticated
    render json: { error: 'Access token is missing or invalid' },
      status: :unauthorized
  end

  # 403
  def not_authorized
    render json: { error: 'You don\'t have permission to do that' },
      status: :forbidden
  end

  # This technically leaks the existance of records which is not ideal. That
  # said, fuck the hackers I want my good status codes (for now).
  # 404
  def not_found
    render json: { error: 'Resource not found' },
      status: :not_found
  end

  # 422
  def not_processable(err)
    render json: { error: err.message }, status: :unprocessable_entity
  end

  # 501
  def endpoint_not_implemented(err)
    render json: { error: err.message }, status: :not_implemented
  end

  # 503
  def service_unavailable
    render json: { error: 'API is currently unavailable' },
      status: :service_unavailable
  end
end
