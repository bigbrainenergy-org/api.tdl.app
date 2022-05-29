# TODO: Not an official part of the API, and I'm too lazy to write the specs atm.
# :nodoc:
class AccessRequestsController < ApplicationController
  skip_before_action :require_login

  def create
    @access_request = AccessRequest.new(access_request_params)

    if recaptcha_passed?
      @access_request.save!
      head :ok
    else
      render json: { error: I18n.t('access_requests.create.recaptcha_failed') },
        status: :bad_request
    end
  end

  private

  def recaptcha_passed?
    verify_recaptcha(
      response: params['recaptcha'],
      action:   'accessRequest'
    )
  end

  def access_request_params
    params.require(:access_request).permit(
      :name,
      :email,
      :reason_for_interest,
      :version
    )
  end
end
# :nodoc:
