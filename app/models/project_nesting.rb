class ProjectNesting < ProjectRelationship
  belongs_to :superproject,
    class_name: 'Project',
    foreign_key: :first_id

  belongs_to :subproject,
    class_name: 'Project',
    foreign_key: :second_id

  # TODO: DRY these validators up

  validates_with AcyclicRelationshipValidator,
    first: :superproject,
    second: :subproject,
    all_firsts: :all_superprojects,
    all_seconds: :all_subprojects

  validates_with RedundantRelationshipValidator,
    first: :superproject,
    second: :subproject,
    all_firsts: :all_superprojects,
    all_seconds: :all_subprojects

  validates_with UselessRelationshipValidator,
    first: :superproject,
    second: :subproject

  validates_with UniqueRelationshipValidator,
    first: :superproject,
    second: :subproject
end
