class TaskHardRequisite < TaskRelationship
  belongs_to :pre,
    class_name:  'Task',
    foreign_key: :first_id,
    inverse_of:  :hard_post_relationships

  belongs_to :post,
    class_name:  'Task',
    foreign_key: :second_id,
    inverse_of:  :hard_pre_relationships

  # TODO: DRY these validators up

  validates_with AcyclicRelationshipValidator,
    first:       :pre,
    second:      :post,
    all_firsts:  :all_hard_prereqs_excl_completed,
    all_seconds: :all_hard_postreqs_excl_completed

  validates_with RedundantRelationshipValidator,
    first:       :pre,
    second:      :post,
    all_firsts:  :all_hard_prereqs_excl_completed,
    all_seconds: :all_hard_postreqs_excl_completed

  validates_with UselessRelationshipValidator,
    first:  :pre,
    second: :post

  validates_with UniqueRelationshipValidator,
    first:  :pre,
    second: :post

  validates_with SameUsersRelationshipValidator,
    first:  :pre,
    second: :post
end
