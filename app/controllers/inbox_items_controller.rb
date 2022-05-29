class InboxItemsController < ApplicationController
  before_action :set_inbox_item, except: [:index, :create]

  def index
    authorize InboxItem

    @inbox_items = policy_scope(InboxItem).order(created_at: :asc)
  end

  def show
    authorize @inbox_item
  end

  def create
    @inbox_item = InboxItem.new(permitted_attributes(InboxItem))
    @inbox_item.user = current_user

    authorize @inbox_item

    @inbox_item.save!

    render :show
  end

  def update
    authorize @inbox_item

    @inbox_item.update!(permitted_attributes(@inbox_item))

    render :show
  end

  def destroy
    authorize @inbox_item

    @inbox_item.destroy!

    head :ok
  end

  private

  def set_inbox_item
    inbox_item_id = params[:inbox_item_id] || params[:id]
    @inbox_item = InboxItem.find(inbox_item_id)
  end
end
