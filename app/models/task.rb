class Task < ApplicationRecord
  belongs_to :list
  belongs_to :user

  has_many :taggings,
    dependent: :destroy

  has_many :pre_rules,
    class_name:  'Rule',
    inverse_of:  :post,
    foreign_key: :post_id,
    dependent:   :destroy
  has_many :post_rules,
    class_name:  'Rule',
    inverse_of:  :pre,
    foreign_key: :pre_id,
    dependent:   :destroy

  has_many :tags,
    -> { order(order: :asc, title: :asc) },
    through: :taggings

  has_many :prereqs,
    class_name: 'Task',
    through:    :pre_rules,
    source:     :pre
  has_many :postreqs,
    class_name: 'Task',
    through:    :post_rules,
    source:     :post

  validates :title,
    presence:   true,
    uniqueness: { case_sensitive: false, scope: :user_id }

  # TODO: Should we validate that task and list owners match, or should that
  #       logic live exclusively within the permission policies?
  validate :list_and_task_owner_match

  def completed?
    completed_at.present?
  end

  # TODO: Use meta programming to DRY up the ISO_8601 conversion?

  # rubocop:disable Naming/VariableNumber
  def completed_at_iso_8601
    iso_8601(completed_at)
  end

  def deadline_at_iso_8601
    iso_8601(deadline_at)
  end

  def prioritize_at_iso_8601
    iso_8601(prioritize_at)
  end

  def remind_me_at_iso_8601
    iso_8601(remind_me_at)
  end

  def review_at_iso_8601
    iso_8601(review_at)
  end

  # rubocop:disable Metrics/MethodLength
  # FIXME: due to the big query stuck in here
  def all_pres
    # rtree - Recursive Tree
    sql = <<-SQL.squish
      WITH RECURSIVE task_tree(id, rtree) AS (
        SELECT t1.id, ARRAY[t1.id] FROM tasks t1
        INNER JOIN rules t2 ON t1.id = t2.pre_id WHERE post_id = #{id}
        UNION ALL
        SELECT t1.id, rtree || t1.id FROM tasks t1
          INNER JOIN rules t2 ON t1.id = t2.pre_id
          INNER JOIN task_tree ptree ON t2.post_id = ptree.id
        WHERE NOT (t1.id = ANY(ptree.rtree))
      )
      SELECT * FROM tasks WHERE id IN (SELECT DISTINCT(id) FROM task_tree);
    SQL
    # FIXME: Sanitize this query!
    # sql = sql_sanitize(sql)
    sql.chomp
    Task.find_by_sql(sql)
  end

  def all_posts
    sql = <<-SQL.squish
      WITH RECURSIVE task_tree(id, rtree) AS (
        SELECT t1.id, ARRAY[t1.id] FROM tasks t1
          INNER JOIN rules t2 ON t1.id = t2.post_id
        WHERE pre_id = #{id}
        UNION ALL
        SELECT t1.id, rtree || t1.id FROM tasks AS t1
          INNER JOIN rules AS t2 ON t1.id = t2.post_id
          INNER JOIN task_tree AS ptree ON t2.pre_id = ptree.id
        WHERE NOT (t1.id = ANY(ptree.rtree))
      )

      SELECT * FROM tasks WHERE id IN (SELECT DISTINCT(id) FROM task_tree);
    SQL
    # FIXME: Sanitize this query!
    # sql = sql_sanitize(sql)
    sql.chomp
    Task.find_by_sql(sql)
  end
  # rubocop:enable Metrics/MethodLength

  private

  def iso_8601(time)
    return nil if time.blank?

    I18n.l(time, format: :iso_8601)
  end
  # rubocop:enable Naming/VariableNumber

  def list_and_task_owner_match
    return unless list.is_a?(List)
    return if user == list&.user

    errors.add(:base, :list_and_task_owner_match)
  end
end
