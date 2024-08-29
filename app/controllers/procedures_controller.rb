class ProceduresController < ApplicationController
  before_action :set_procedure, except: [:index, :create]

  def index
    authorize Procedure
    @procedures = policy_scope(Procedure).order(created_at: :asc)
  end

  def show
    authorize @procedure
  end

  def create
    @procedure = Procedure.new(permitted_attributes(Procedure))
    @procedure.user = current_user
    authorize @procedure
    @procedure.save!
    render :show
  end

  def update
    authorize @procedure
    @procedure.update!(permitted_attributes(@procedure))
    render :show
  end

  def destroy
    authorize @procedure
    @procedure.destroy!
    head :ok
  end
end