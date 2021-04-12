class UsersController < ApplicationController
  before_action :set_user

  def time_zone
    authorize @user
  end

  def update_time_zone
    authorize @user

    @user.update!(time_zone_params)

    render :time_zone
  end

  private

  def set_user
    # user_id = params[:user_id] || params[:id]
    # @user = User.find(user_id)
    @user = current_user
    raise ActiveRecord::RecordNotFound if @user.nil?
  end

  def time_zone_params
    params.permit(:time_zone)
  end
end
