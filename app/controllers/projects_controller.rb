class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :create, :sync_ordering]

  def index
    authorize Project

    @projects = policy_scope(Project)
      .includes(:superprojects)
      .includes(:subprojects)
      .order(order: :asc, title: :asc)
  end

  def show
    authorize @project
  end

  def create
    @project = Project.new(permitted_attributes(Project))
    @project.user = current_user

    authorize @project

    @project.save!

    render :show
  end

  def update
    authorize @project

    @project.update!(project_params)

    render :show
  end

  def destroy
    authorize @project

    @project.destroy!

    head :ok
  end

  def bulk_update_same_values
    authorize Project

    permitted_ids = policy_scope(Project).select(:id)

    check_permissions(Project, params)

    @projects = Project.bulk_update!(permitted_attributes(Project))

    render :index
  end

  def bulk_update_unique_values

  end

  # FIXME: This level of complexity is a code smell, fix it.
  # rubocop:disable Metrics
  def sync_ordering
    authorize Project

    projects = policy_scope(Project)

    # TODO: Find the best way to test these edge cases / move them into the
    #       model so it can be unit tested.
    # :nocov:
    raise ActionController::ParameterMissing, :projects if params[:projects].blank?

    unless params[:projects].is_a?(Array)
      raise ArgumentError, 'Projects must be an array'
    end

    # :nocov:

    Project.transaction do
      params[:projects].each do |project_order|
        project = projects.find { |l| l.id == project_order[:id] }
        raise Pundit::NotAuthorizedError if project.nil?
        next if project.order == project_order[:order]
        unless project_order[:order].is_a?(Integer)
          raise ArgumentError, 'Order must be an integer'
        end

        project.update!(order: project_order[:order])
      end
    end

    head :ok
  rescue ArgumentError => e
    not_processable(e)
  end
  # rubocop:enable Metrics

  private

  def set_project
    project_id = params[:project_id] || params[:id]
    @project = Project.find(project_id)
  end

  def bulk_project_update_params
    params.require(:projects).permit(:title, :notes)
  end
end
