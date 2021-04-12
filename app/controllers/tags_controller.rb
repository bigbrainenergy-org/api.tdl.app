class TagsController < ApplicationController
  before_action :set_tag, except: [:index, :create, :sync_ordering]

  def index
    authorize Tag

    @tags = policy_scope(Tag).order(order: :asc, title: :asc)
  end

  def show
    authorize @tag
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user = current_user
    @tag.randomize_color! if @tag.color.nil?

    authorize @tag

    @tag.save!

    render :show
  end

  def update
    authorize @tag

    @tag.update!(tag_params)

    render :show
  end

  def destroy
    authorize @tag

    @tag.destroy!

    head :ok
  end

  # FIXME: This level of complexity is a code smell, fix it.
  # rubocop:disable Metrics
  def sync_ordering
    authorize Tag

    tags = policy_scope(Tag)

    # TODO: Find the best way to test these edge cases / move them into the
    #       model so it can be unit tested.
    # :nocov:
    raise ActionController::ParameterMissing, :tags if params[:tags].blank?

    unless params[:tags].is_a?(Array)
      raise ArgumentError, 'Tags must be an array'
    end

    # :nocov:

    Tag.transaction do
      params[:tags].each do |tag_order|
        tag = tags.find { |l| l.id == tag_order[:id] }
        raise Pundit::NotAuthorizedError if tag.nil?
        next if tag.order == tag_order[:order]
        unless tag_order[:order].is_a?(Integer)
          raise ArgumentError, 'Order must be an integer'
        end

        tag.update!(order: tag_order[:order])
      end
    end

    head :ok
  rescue ArgumentError => e
    not_processable(e)
  end
  # rubocop:enable Metrics

  private

  def set_tag
    tag_id = params[:tag_id] || params[:id]
    @tag = Tag.find(tag_id)
  end

  def tag_params
    params.require(:tag).permit(:title, :order, :color)
  end
end
