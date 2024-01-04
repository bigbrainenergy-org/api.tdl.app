class ListsController < ApplicationController
  before_action :set_list, except: [:index, :create]

  def index
    authorize List
    @lists = policy_scope(List).order(created_at: :asc)
  end

  def show
    authorize @list
  end

  def create
    @list = List.new(permitted_attributes(List))
    @list.user = current_user
    authorize @list
    @list.save!
    render :show
  end

  def update
    authorize @list
    @list.update!(permitted_attributes(@list))
    render :show
  end

  def destroy
    authorize @list
    @list.destroy!
    head :ok
  end

  private

  def set_list
    list_id = params[:list_id] || params[:id]
    @list = List.find(list_id)
  end
end
