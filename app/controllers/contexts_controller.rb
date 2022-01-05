class ContextsController < ApplicationController
  before_action :set_context, except: [:index, :create]

  def index
    authorize Context

    @contexts = policy_scope(Context).order(created_at: :asc)
  end

  def show
    authorize @context
  end

  def create
    @context = Context.new(permitted_attributes(Context))
    @context.user = current_user

    authorize @context

    @context.save!

    render :show
  end

  def update
    authorize @context

    @context.update!(permitted_attributes(@context))

    render :show
  end

  def destroy
    authorize @context

    @context.destroy!

    head :ok
  end

  private

  def set_context
    context_id = params[:context_id] || params[:id]
    @context = Context.find(context_id)
  end
end
