class ProjectHardRequisite < ProjectRelationship
  belongs_to :pre,
    class_name: 'Project',
    foreign_key: :first_id

  belongs_to :post,
    class_name: 'Project',
    foreign_key: :second_id

  # TODO: DRY these validators up

  validates_with AcyclicRelationshipValidator,
    first: :pre,
    second: :post,
    all_firsts: :all_hard_prereqs,
    all_seconds: :all_hard_postreqs

  validates_with RedundantRelationshipValidator,
    first: :pre,
    second: :post,
    all_firsts: :all_hard_prereqs,
    all_seconds: :all_hard_postreqs

  validates_with UselessRelationshipValidator,
    first: :pre,
    second: :post

  validates_with UniqueRelationshipValidator,
    first: :pre,
    second: :post
end
