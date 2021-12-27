class ProjectRelationshipsController < ApplicationController
  def index
    authorize ProjectRelationship

    @project_relationships = policy_scope(ProjectRelationship).all
  end
end
