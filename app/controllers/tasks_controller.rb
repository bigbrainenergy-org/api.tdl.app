class TasksController < ApplicationController
  before_action :set_task, except: [:index, :create]

  def index
    authorize Task

    @tasks = policy_scope(Task)
             .includes(:list)
             .includes(:status)
             .includes(:hard_prereqs)
             .includes(:hard_postreqs)
             .includes(:procedures)
             .order(created_at: :asc)
  end

  def show
    authorize @task
  end

  def create
    @task = Task.new(permitted_attributes(Task))
    @task.list = current_user.default_list if @task.list.nil?

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

  def bulk
    case request.method_symbol
    when :get
      authorize Task
      @tasks = policy_scope(Task)
               .includes(:list)
               .includes(:status)
               .includes(:hard_prereqs)
               .includes(:hard_postreqs)
               .includes(:procedures)
               .order(created_at: :asc)
    when :patch
      # validate all before processing
      # Update multiple tasks.
      Task.transaction do
        params.each do |task_param|
          current_task = Task.find(task_param[:id])
          current_task.update!(permitted_attributes(@task).except(:id))
        end
      end
    when :post
      # Create multiple tasks.
      Task.transaction do
        params.each do |task_param|
          current_task = Task.new(permitted_attributes(Task))
          current_task.list = current_user.default_list if current_task.list.nil?
          authorize current_task
          current_task.save!
        end
      end
      render :show
    end
  end

  private

  def set_task
    task_id = params[:task_id] || params[:id]
    @task = Task.find(task_id)
  end
end
