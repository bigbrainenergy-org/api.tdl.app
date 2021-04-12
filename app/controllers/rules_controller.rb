class RulesController < ApplicationController
  def index
    authorize Rule

    @rules = policy_scope(Rule).all
  end
end
