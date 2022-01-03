class NextActionHardRequisite < NextActionRelationship
  belongs_to :pre,
    class_name: 'NextAction',
    foreign_key: :first_id,
    inverse_of: :hard_post_relationships

  belongs_to :post,
    class_name: 'NextAction',
    foreign_key: :second_id,
    inverse_of: :hard_pre_relationships

  validates :pre, uniqueness: { scope: :second_id }
  validates :post, uniqueness: { scope: :first_id }

  validates_with AcyclicRelationship,
    first: :pre,
    second: :post,
    all_firsts: :all_pres,
    all_seconds: :all_seconds
end
