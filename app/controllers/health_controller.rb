class HealthController < ApplicationController
  skip_before_action :require_login

  def health
    User.any? # Force a DB connection to see if the database is healthy
    render json: { status: 'healthy' }
  rescue StandardError
    service_unavailable
  end
end
