class ProjectHardRequisite < ProjectRelationship
  belongs_to :pre,
    class_name: 'Project',
    foreign_key: :first_id

  belongs_to :post,
    class_name: 'Project',
    foreign_key: :second_id
end
