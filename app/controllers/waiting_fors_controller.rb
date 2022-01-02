class WaitingForsController < ApplicationController
  before_action :set_waiting_for, except: [:index, :create]

  def index
    authorize WaitingFor

    @waiting_fors = policy_scope(WaitingFor).order(created_at: :asc)
  end

  def show
    authorize @waiting_for
  end

  def create
    @waiting_for = WaitingFor.new(permitted_attributes(WaitingFor))
    @waiting_for.user = current_user

    authorize @waiting_for

    @waiting_for.save!

    render :show
  end

  def update
    authorize @waiting_for

    @waiting_for.update!(permitted_attributes(@waiting_for))

    render :show
  end

  def destroy
    authorize @waiting_for

    @waiting_for.destroy!

    head :ok
  end

  private

  def set_waiting_for
    waiting_for_id = params[:waiting_for_id] || params[:id]
    @waiting_for = WaitingFor.find(waiting_for_id)
  end
end
