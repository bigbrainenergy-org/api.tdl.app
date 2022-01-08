class NextActionsController < ApplicationController
  before_action :set_next_action, except: [:index, :create]

  def index
    authorize NextAction

    @next_actions = policy_scope(NextAction)
      .includes(:project)
      .includes(:context)
      .includes(:hard_prereqs)
      .includes(:hard_postreqs)
      .order(created_at: :asc)
  end

  def show
    authorize @next_action
  end

  def create
    @next_action = NextAction.new(permitted_attributes(NextAction))
    @next_action.user = current_user

    authorize @next_action

    @next_action.save!

    render :show
  end

  def update
    authorize @next_action

    @next_action.update!(permitted_attributes(@next_action))

    render :show
  end

  def destroy
    authorize @next_action

    @next_action.destroy!

    head :ok
  end

  private

  def set_next_action
    next_action_id = params[:next_action_id] || params[:id]
    @next_action = NextAction.find(next_action_id)
  end
end
