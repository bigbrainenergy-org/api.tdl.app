class NextActionRelationshipsController < ApplicationController
  def index
    authorize NextActionRelationship

    @next_action_relationships = policy_scope(NextActionRelationship).all
  end
end
