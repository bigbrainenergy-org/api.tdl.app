json.array! @lists do |list|
  json.call(list, :id, :title, :order, :icon, :color)
  # Necessary because of no front-end support for join model relationships
end
