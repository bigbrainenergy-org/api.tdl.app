class StatusesController < ApplicationController
  before_action :set_status, except: [:index, :create]

  def index
    authorize Status

    @statuses = policy_scope(Status)
      .includes(:tasks)
      .order(order: :asc)
  end

  def show
    authorize @status
  end

  def create
    @status = Status.new(permitted_attributes(Status))
    @status.user = current_user

    authorize @status

    @status.save!

    render :show
  end

  def update
    authorize @status

    @status.update!(permitted_attributes(@status))

    render :show
  end

  def destroy
    authorize @status

    @status.destroy!

    head :ok
  end

  private

  def set_status
    status_id = params[:status_id] || params[:id]
    @status = Status.find(status_id)
  end
end