json.array! @projects do |project|
  json.call(project, :id, :title, :notes, :order)
  # Necessary because of no front-end support for join model relationships
  json.superproject_ids project.superprojects.map(&:id)
  json.subproject_ids project.subprojects.map(&:id)
end
