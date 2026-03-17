class SchedulesController < ApplicationController
  before_action :set_schedule, except: [:index, :create]

  def index
    authorize Schedule
    @schedules = policy_scope(Schedule).order(created_at: :asc)
  end

  def show
    authorize @schedule
  end

  def create
    @schedule = Schedule.new(permitted_attributes(Schedule))
    @schedule.user = current_user
    authorize @schedule
    @schedule.save!
    render :show
  end

  def update
    authorize @schedule
    @schedule.update!(permitted_attributes(@schedule))
    render :show
  end

  def destroy
    authorize @schedule
    @schedule.destroy!
    head :ok
  end

  private

  def set_schedule
    schedule_id = params[:schedule_id] || params[:id]
    @schedule = Schedule.find(schedule_id)
  end
end
