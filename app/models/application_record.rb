class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def _write_attribute(attr_name, value)
    if value.is_a?(String) && value.present?
      super(attr_name, value.delete("\u0000"))
    else
      super
    end
  end

  # TODO: Code smell indicates this can be extracted into a new object.
  # rubocop:disable Metrics/MethodLength
  def recursive_relationship_find(klass:, klass_table: nil, join_table:, join_type:, starting_id:, finding:)
    # Allow overwriting table name if it doesn't follow convention
    klass_table = sanitize_sql(klass.name.underscore.pluralize) if klass_table.nil?
    # Sanitize all inputs
    join_table = sanitize_sql(join_table)
    join_type = sanitize_sql(join_type)
    starting_id = sanitize_sql(starting_id)
    finding = sanitize_sql(finding)

    # Make sure we don't accidentally use an invalid input
    raise ArgumentError if ![:first, :second].include?(finding)

    coming_from = (finding == :first) ? 'second' : 'first'

    # rtree - Recursive Tree
    # NOTE: Must use /* */ style comments due to `.squish`
    sql = <<-SQL.squish
      WITH RECURSIVE full_tree(id, rtree) AS (
        SELECT record.id, ARRAY[record.id] FROM #{klass_table} record
          INNER JOIN #{join_table} relationship ON record.id = relationship.#{finding}_id
        WHERE #{coming_from}_id = #{starting_id}
          AND relationship.type = \'#{join_type}\'
        UNION ALL
        SELECT record.id, rtree || record.id FROM #{klass_table} record
          INNER JOIN #{join_table} relationship ON record.id = relationship.#{finding}_id
          INNER JOIN full_tree ptree ON relationship.#{coming_from}_id = ptree.id
        WHERE NOT (record.id = ANY(ptree.rtree))
          AND relationship.type = \'#{join_type}\'
      )
      SELECT * FROM #{klass_table} WHERE id IN (SELECT DISTINCT(id) FROM full_tree);
    SQL
    # FIXME: Sanitize this query!
    # sql = sql_sanitize(sql)
    sql.chomp
    klass.find_by_sql(sql)
  end
  # rubocop:enable Metrics/MethodLength
end
