class TaskDependency < TaskRelationship
  belongs_to :pre,
    class_name:  'Task',
    foreign_key: :first_id,
    inverse_of:  :post_relationships

  belongs_to :post,
    class_name:  'Task',
    foreign_key: :second_id,
    inverse_of:  :pre_relationships

  validates :degree, inclusion: { in: [1, 2, 3] }, allow_nil: true

  # TODO: DRY these validators up

  validates_with AcyclicRelationshipValidator,
    first:       :pre,
    second:      :post,
    all_firsts:  :all_prereqs_excl_completed,
    all_seconds: :all_postreqs_excl_completed,
    on: :create

  validates_with RedundantRelationshipValidator,
    first:       :pre,
    second:      :post,
    all_firsts:  :all_prereqs_excl_completed,
    all_seconds: :all_postreqs_excl_completed,
    on: :create

  validates_with UselessRelationshipValidator,
    first:  :pre,
    second: :post,
    on: :create

  validates_with UniqueRelationshipValidator,
    first:  :pre,
    second: :post,
    on: :create

  validates_with SameUsersRelationshipValidator,
    first:  :pre,
    second: :post
end
