class SubtasksController < ApplicationController
  before_action :set_subtask, except: [:index, :create]

  def index
    authorize Subtask

    @subtasks = policy_scope(Subtask).order(created_at: :asc)
  end

  def show
    authorize @subtask
  end

  def create
    @subtask = Subtask.new(permitted_attributes(Subtask))
    @subtask.user = current_user

    authorize @subtask

    @subtask.save!

    render :show
  end

  def update
    authorize @subtask

    @subtask.update!(permitted_attributes(@subtask))

    render :show
  end

  def destroy
    authorize @subtask

    @subtask.destroy!

    head :ok
  end

  private

  def set_subtask
    subtask_id = params[:subtask_id] || params[:id]
    @subtask = Subtask.find(subtask_id)
  end
end
