class UsersController < ApplicationController
  before_action :set_user

  def show
    authorize @user
  end

  def update
    authorize @user

    @user.update!(permitted_attributes(@user))

    render :show
  end

  private

  def set_user
    user_id = params[:user_id] || params[:id]
    @user = User.find(user_id)
    # @user = current_user
    # raise ActiveRecord::RecordNotFound if @user.nil?
  end
end
