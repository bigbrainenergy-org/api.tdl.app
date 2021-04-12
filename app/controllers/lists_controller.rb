class ListsController < ApplicationController
  before_action :set_list, except: [:index, :create, :sync_ordering]

  def index
    authorize List

    @lists = policy_scope(List).order(order: :asc, title: :asc)
  end

  def show
    authorize @list
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user

    authorize @list

    @list.save!

    render :show
  end

  def update
    authorize @list

    @list.update!(list_params)

    render :show
  end

  def destroy
    authorize @list

    @list.destroy!

    head :ok
  end

  # FIXME: This level of complexity is a code smell, fix it.
  # rubocop:disable Metrics
  def sync_ordering
    authorize List

    lists = policy_scope(List)

    # TODO: Find the best way to test these edge cases / move them into the
    #       model so it can be unit tested.
    # :nocov:
    raise ActionController::ParameterMissing, :lists if params[:lists].blank?

    unless params[:lists].is_a?(Array)
      raise ArgumentError, 'Lists must be an array'
    end

    # :nocov:

    List.transaction do
      params[:lists].each do |list_order|
        list = lists.find { |l| l.id == list_order[:id] }
        raise Pundit::NotAuthorizedError if list.nil?
        next if list.order == list_order[:order]
        unless list_order[:order].is_a?(Integer)
          raise ArgumentError, 'Order must be an integer'
        end

        list.update!(order: list_order[:order])
      end
    end

    head :ok
  rescue ArgumentError => e
    not_processable(e)
  end
  # rubocop:enable Metrics

  private

  def set_list
    list_id = params[:list_id] || params[:id]
    @list = List.find(list_id)
  end

  def list_params
    params.require(:list).permit(:title, :order)
  end
end
