class ProjectNesting < ProjectRelationship
  belongs_to :superproject,
    class_name: 'Project',
    foreign_key: :first_id

  belongs_to :subproject,
    class_name: 'Project',
    foreign_key: :second_id
end
