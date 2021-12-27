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

  def randomize_color!
    temp = color.presence || ' '
    self.color = temp
    self.color = "##{Random.hex(3)}" while temp.casecmp(color).zero?

    # expectations:
    # ''      | #random
    # nil     | #random
    # #any    | #random
  end
end
