class ProjectRelationship < ApplicationRecord
  belongs_to :first
  belongs_to :second

  enum kind: {
    requisite: 'requisite', # Pre/postrequisite
    nesting: 'nesting',     # Super/subproject nesting
    related: 'related'      # Related, but not nested or a requisite
  }
end
