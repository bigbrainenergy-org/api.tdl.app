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

  def change_password
    authorize @user

    if params[:user][:password].empty? || params[:user][:current_password].empty?
      render json: { error: I18n.t('users.change_password.missing_password') },
        status: :bad_request
      return
    end

    if params[:user][:password] == params[:user][:current_password]
      render json: { error: I18n.t('users.change_password.same_password') },
        status: :bad_request
      return
    end

    unless @user.valid_password?(params[:user][:current_password])
      render json: { error: I18n.t('users.change_password.invalid_current_password') },
        status: :bad_request
      return
    end

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
