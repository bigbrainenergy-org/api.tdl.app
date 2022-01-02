class Context < ApplicationRecord
  belongs_to :user

  has_many :next_actions

  validates :title, :icon,
    presence: true

  validates :color,
    presence:             true,
    hex_color_formatting: true

  validates :title,
    uniqueness: { case_sensitive: false, scope: :user_id }

  before_validation :randomize_by_default, only: [:create]

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
