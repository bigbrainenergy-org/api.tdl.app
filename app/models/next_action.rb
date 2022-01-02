class NextAction < ApplicationRecord
  belongs_to :user
  belongs_to :context, optional: true
  belongs_to :project, optional: true

  has_many :hard_pre_relationships,
    class_name:  'NextActionHardRequisite',
    inverse_of:  :post,
    foreign_key: :second_id,
    dependent:   :destroy
  has_many :hard_post_relationships,
    class_name:  'NextActionHardRequisite',
    inverse_of:  :pre,
    foreign_key: :first_id,
    dependent:   :destroy

  has_many :hard_prereqs,
    class_name: 'NextAction',
    through: :hard_pre_relationships,
    source: :pre
  has_many :hard_postreqs,
    class_name: 'NextAction',
    through: :hard_post_relationships,
    source: :post
end
