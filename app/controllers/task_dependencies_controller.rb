class TaskDependenciesController < ApplicationController
  before_action :set_task_dependency, except: [:index, :create]

  def index
    authorize TaskDependency

    @task_dependencies = policy_scope(TaskDependency).order(created_at: :asc)
  end

  def show
    authorize @task_dependency
  end

  def create
    def create
    Rails.logger.error("=== PARAMS: #{params.inspect}")
    Rails.logger.error("=== PERMITTED: #{permitted_attributes(TaskDependency).inspect}")
    @task_dependency = TaskDependency.new(permitted_attributes(TaskDependency))

    authorize @task_dependency

    @task_dependency.save!

    render :show
  end

  def update
    authorize @task_dependency

    @task_dependency.update!(permitted_attributes(@task_dependency))

    render :show
  end

  def destroy
    authorize @task_dependency

    @task_dependency.destroy!

    head :ok
  end

  private

  def set_task_dependency
    task_dependency_id = params[:task_dependency_id] || params[:id]
    @task_dependency = TaskDependency.find(task_dependency_id)
  end
end
