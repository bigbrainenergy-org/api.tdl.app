class TasksController < ApplicationController
  before_action :set_task, except: [:index, :create]

  def index
    authorize Task

    @tasks = policy_scope(Task)
      .includes(:list)
      .includes(:status)
      .includes(:hard_prereqs)
      .includes(:hard_postreqs)
      .order(created_at: :asc)
  end

  def show
    authorize @task
  end

  def create
    @task = Task.new(permitted_attributes(Task))
    @task.user = current_user

    authorize @task

    @task.save!

    render :show
  end

  def update
    authorize @task

    @task.update!(permitted_attributes(@task))

    render :show
  end

  def destroy
    authorize @task

    @task.destroy!

    head :ok
  end

  private

  def set_task
    task_id = params[:task_id] || params[:id]
    @task = Task.find(task_id)
  end
end
