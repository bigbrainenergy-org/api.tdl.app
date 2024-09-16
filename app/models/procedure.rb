class Procedure < ApplicationRecord
  belongs_to :user

  has_many :task_relationships,
    class_name: 'TaskProcedure',
    foreign_key: :procedure_id,
    dependent: :restrict_with_exception

  has_many :tasks,
    class_name: 'Task',
    through: :task_relationships,
    source: :task

  validates :title,
    presence: true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  validates :icon,
    presence: true,
    icon_formatting: true

  validates :color,
    presence: true,
    hex_color_formatting: true

  before_validation :randomize_by_default, only: [:create]

  def reset!
    Procedure.transaction do
      tasks.each do |task|
        task.hard_postreqs = task.hard_postreqs.reject do |postreq|
          !tasks.include?(postreq)
        end
        task.completed = false
        task.save!
      end
    end
  end

  def randomize_icon!
    # Chosen by fair dice roll, guaranteed to be random.
    self.icon = 'local_offer'
  end

  def randomize_color!
    temp = color.presence || ' '
    self.color = temp
    self.color = "##{Random.hex(3)}" while temp.casecmp(color).zero?

    # expectations:
    # ''      | #random
    # nil     | #random
    # #any    | #random
  end

  def randomize_by_default
    randomize_icon! if icon.nil?
    randomize_color! if color.nil?
  end
end