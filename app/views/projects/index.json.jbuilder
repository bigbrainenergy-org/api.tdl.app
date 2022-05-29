json.array! @projects do |project|
  json.call(project, :id, :title, :notes, :order, :status, :status_last_changed_at, :deadline_at, :estimated_time_to_complete)
  # Necessary because of no front-end support for join model relationships
  json.superproject_ids project.superprojects.map(&:id)
  json.subproject_ids project.subprojects.map(&:id)
end
