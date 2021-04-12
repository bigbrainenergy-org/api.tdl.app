# FIXME: class length 192 > 100
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
class TasksController < ApplicationController
  before_action :set_task,
    except: [:index, :clear_completed, :create, :sync_ordering, :bulk]

  def index
    authorize Task

    @tasks = policy_scope(Task)
             .includes(:tags)
             .includes(:prereqs)
             .includes(:postreqs)
             .order(order: :asc, title: :asc)
  end

  def clear_completed
    authorize Task

    policy_scope(Task)
      .where(user: current_user)
      .where.not(completed_at: nil)
      .destroy_all

    @tasks = policy_scope(Task).order(order: :asc, title: :asc)

    render :index
  end

  def show
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if params[:tag_ids].present?
      unless params[:tag_ids].is_a?(Array)
        raise ArgumentError, 'tag_ids must be an array'
      end

      @task.tags = []
      allowed_tags = policy_scope(Tag)

      params[:tag_ids].each do |tag_id|
        tag = allowed_tags.find_by(id: tag_id)
        raise Pundit::NotAuthorizedError if tag.nil?

        @task.tags << tag
      end
    end

    authorize @task

    @task.save!

    render :show
  rescue ArgumentError => e
    not_processable(e)
  end

  def update
    authorize @task

    @task.update!(task_params)

    render :show
  end

  def destroy
    authorize @task

    @task.destroy!

    head :ok
  end

  # FIXME: This level of complexity is a code smell, fix it.
  def sync_ordering
    authorize Task

    tasks = policy_scope(Task)

    # TODO: Find the best way to test these edge cases / move them into the
    #       model so it can be unit tested.
    # :nocov:
    raise ActionController::ParameterMissing, :tasks if params[:tasks].blank?

    unless params[:tasks].is_a?(Array)
      raise ArgumentError, 'Tasks must be an array'
    end

    # :nocov:

    Task.transaction do
      params[:tasks].each do |task_order|
        task = tasks.find { |l| l.id == task_order[:id] }
        raise Pundit::NotAuthorizedError if task.nil?
        next if task.order == task_order[:order]
        unless task_order[:order].is_a?(Integer)
          raise ArgumentError, 'Order must be an integer'
        end

        task.update!(order: task_order[:order])
      end
    end

    head :ok
  rescue ArgumentError => e
    not_processable(e)
  end

  def mark_complete
    authorize @task

    if @task.completed?
      render json: { error: 'Already marked as complete' },
        status: :unprocessable_entity
      return
    end

    @task.update!(completed_at: Time.current)

    render :show
  end

  def mark_incomplete
    authorize @task

    unless @task.completed?
      render json: { error: 'Already marked as incomplete' },
        status: :unprocessable_entity
      return
    end

    @task.update!(completed_at: nil)

    render :show
  end

  def update_tags
    authorize @task

    allowed_tags = policy_scope(Tag)
    task_tags = []

    params[:tags]&.each do |potential_tag|
      tag = allowed_tags.find { |t| t.id == potential_tag[:id] }
      raise Pundit::NotAuthorizedError if tag.nil?

      task_tags << tag
    end

    @task.tags = task_tags
    @task.save!

    render :show
  end

  def update_list
    authorize @task

    list = policy_scope(List).find(params[:list_id])
    raise Pundit::NotAuthorizedError if list.nil?

    @task.list = list
    @task.save!

    render :show
  end

  def bulk
    authorize Task

    tasks = policy_scope(Task)

    # TODO: Find the best way to test these edge cases / move them into the
    #       model so it can be unit tested.
    # :nocov:
    if params[:task_ids].blank?
      raise ActionController::ParameterMissing,
        :task_ids
    end

    unless params[:task_ids].is_a?(Array)
      raise ArgumentError, 'Tasks must be an array'
    end

    # :nocov:

    Task.transaction do
      params[:task_ids].each do |task_id|
        task = tasks.find { |l| l.id == task_id }
        raise Pundit::NotAuthorizedError if task.nil?

        task.update!(task_params)
      end
    end

    # This mildly spikes my danger senses...Double check that this is sane
    @tasks = policy_scope(Task).where(id: params[:task_ids])

    render :index
  rescue ArgumentError => e
    not_processable(e)
  end

  # FIXME: Pre/post req stuff should live in the rules controller
  def add_prerequisite
    authorize @task

    prereq = policy_scope(Task).find_by(id: params[:pre_task_id])

    raise Pundit::NotAuthorizedError if prereq.nil?

    Rule.create!(pre: prereq, post: @task)

    # Reload so that we pick up on the new pre/post relationships
    @tasks = [@task.reload, prereq.reload]

    render :index
  end

  def add_postrequisite
    authorize @task

    postreq = policy_scope(Task).find_by(id: params[:post_task_id])

    raise Pundit::NotAuthorizedError if postreq.nil?

    Rule.create!(pre: @task, post: postreq)

    # Reload so that we pick up on the new pre/post relationships
    @tasks = [@task.reload, postreq.reload]

    render :index
  end

  def remove_prerequisite
    authorize @task

    prereq = policy_scope(Task).find_by(id: params[:pre_task_id])

    raise Pundit::NotAuthorizedError if prereq.nil?

    # Raise a 404 error if no rule found
    rule = Rule.find_by!(pre: prereq, post: @task)
    rule.destroy!

    # Reload so that we pick up on the new pre/post relationships
    @tasks = [@task.reload, prereq.reload]

    render :index
  end

  def remove_postrequisite
    authorize @task

    postreq = policy_scope(Task).find_by(id: params[:post_task_id])

    raise Pundit::NotAuthorizedError if postreq.nil?

    # Raise a 404 error if no rule found
    rule = Rule.find_by!(pre: @task, post: postreq)
    rule.destroy!

    # Reload so that we pick up on the new pre/post relationships
    @tasks = [@task.reload, postreq.reload]

    render :index
  end

  private

  def set_task
    task_id = params[:task_id] || params[:id]
    @task = Task.find(task_id)
  end

  def task_params
    params.require(:task).permit(
      :title,
      :order,
      :list_id,
      :tag_ids,
      :notes,
      :review_at,
      :remind_me_at,
      :prioritize_at,
      :deadline_at
    )
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
