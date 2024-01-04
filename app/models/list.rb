class List < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :restrict_with_exception

  has_one :user_who_defaulted_this_list,
    class_name:  'User',
    foreign_key: :default_list_id,
    inverse_of:  :default_list,
    dependent:   :restrict_with_exception

  validates :title,
    presence:   true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  validates :order,
    presence: true

  validates :icon,
    presence:        true,
    icon_formatting: true

  validates :color,
    presence:             true,
    hex_color_formatting: true

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
