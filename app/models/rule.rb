class Rule < ApplicationRecord
  belongs_to :pre,
    class_name: 'Task',
    inverse_of: :post_rules
  belongs_to :post,
    class_name: 'Task',
    inverse_of: :pre_rules

  validates :pre, uniqueness: { scope: :post_id }
  validates :post, uniqueness: { scope: :pre_id }

  validates_with RuleUselessValidator,
    RuleAcyclicValidator,
    RuleRedundancyValidator,
    RuleUniquenessValidator
  # after_save :prune_redundant_rules

  # FIXME: Mark instead of prune!
  # def prune_redundant_rules
  #   Rule.where(pre: pre.all_pres, post: post).find_each do |rule|
  #     rule.destroy! if rule.invalid?
  #   end
  #
  #   Rule.where(pre: pre, post: post.all_posts).find_each do |rule|
  #     rule.destroy! if rule.invalid?
  #   end
  # end
end
