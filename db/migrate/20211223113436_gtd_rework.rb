# rubocop:disable Metrics
class GtdRework < ActiveRecord::Migration[6.1]
  # The original models will be nuked at time of migration, so copy the parts we
  # need for the duration of the migration.
  class Task < ApplicationRecord
    belongs_to :list
    belongs_to :user
    has_many :taggings
    has_many :pre_rules,
      class_name:  'Rule',
      inverse_of:  :post,
      foreign_key: :post_id
    has_many :post_rules,
      class_name:  'Rule',
      inverse_of:  :pre,
      foreign_key: :pre_id
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
  end

  class List < ApplicationRecord; end

  class Tag < ApplicationRecord; end

  class Rule < ApplicationRecord
    belongs_to :pre,
      class_name: 'Task',
      inverse_of: :post_rules
    belongs_to :post,
      class_name: 'Task',
      inverse_of: :pre_rules
  end

  class Tagging < ApplicationRecord
    belongs_to :tag
    belongs_to :task
  end

  def up
    #######################
    ## Create new tables ##
    #######################

    # Intentionally does not support ordering. Doesn't matter how important it
    # is, everything should get to inbox 0, and never come back to the inbox.
    create_table :inbox_items do |t|
      t.belongs_to :user,  null: false, foreign_key: true
      t.string     :title, null: false
      t.string     :notes

      t.timestamps
    end

    create_table :contexts do |t|
      t.belongs_to :user,  null: false, foreign_key: true
      t.string     :title, null: false
      t.string     :color, null: false
      t.string     :icon,  null: false
      t.integer    :order, null: false, default: 0

      t.timestamps
    end

    add_index :contexts, [:title, :user_id], unique: true

    create_table :projects do |t|
      t.belongs_to :user,   null: false, foreign_key: true
      t.string     :title,  null: false
      t.string     :notes
      t.integer    :order,  null: false, default: 0
      t.string     :status, null: false, default: 'active'
      t.datetime   :status_last_changed_at
      t.datetime   :deadline_at
      t.string     :estimated_time_to_complete

      t.timestamps
    end

    add_index :projects, [:title, :user_id], unique: true

    create_table :next_actions do |t|
      t.belongs_to :user,      null: false, foreign_key: true
      t.belongs_to :context,   foreign_key: true
      t.belongs_to :project,   foreign_key: true
      t.string     :title,     null: false
      t.string     :notes
      t.integer    :order,     null: false, default: 0
      t.boolean    :completed, null: false, default: false
      t.datetime   :remind_me_at

      t.timestamps
    end

    create_table :next_action_relationships do |t|
      t.string     :type,   null: false
      t.belongs_to :first,  null: false
      t.belongs_to :second, null: false
      t.string     :notes

      t.timestamps
    end

    add_index :next_action_relationships, [:first_id, :second_id, :type], unique: true, name: 'unique_next_action_relationships'

    create_table :waiting_fors do |t|
      t.belongs_to :user,            null: false, foreign_key: true
      t.belongs_to :project,         foreign_key: true
      t.string     :title,           null: false
      t.string     :notes
      t.integer    :order,           null: false, default: 0
      t.datetime   :next_checkin_at
      t.string     :delegated_to
      t.boolean    :completed,       null: false, default: false

      t.timestamps
    end

    # Simple bullet list for a next action. Anything more complicated should be
    # broken down as project(s)/next action(s)
    #
    # Maybe include a warning that these should just be components of a larger
    # task?
    create_table :subtasks do |t|
      t.belongs_to :next_action, null: false, foreign_key: true
      t.string     :title,       null: false
      t.integer    :order,       null: false, default: 0
      t.boolean    :completed,   null: false, default: false

      t.timestamps
    end

    create_table :project_relationships do |t|
      t.string     :type,   null: false
      t.belongs_to :first,  null: false
      t.belongs_to :second, null: false
      t.string     :notes

      t.timestamps
    end

    add_index :project_relationships, [:first_id, :second_id, :type], unique: true, name: 'unique_project_relationships'

    ##################
    ## Migrate Data ##
    ##################

    User.all.find_each do |user|
      user.prepopulate_contexts!
    end

    Task.all.includes(
      :user,
      :list,
      :tags,
      :prereqs,
      :postreqs
    ).find_each do |task|
      notes =
        "#{task.notes}\n\n"\
        "--- Metadata ---\n\n"\
        "List: #{task.list.title}"

      if task.tags.any?
        notes += "\nTags: \"#{task.tags.map(&:title).join('", "')}\""
      end
      if task.prereqs.any?
        notes += "\nPrereqs: \"#{task.prereqs.map(&:title).join('", "')}\""
      end
      if task.postreqs.any?
        notes += "\nPostreqs: \"#{task.postreqs.map(&:title).join('", "')}\""
      end
      # rubocop:disable Naming/VariableNumber
      if task.completed_at.present?
        notes += "\nCompleted At: #{
          I18n.l(task.completed_at, format: :iso_8601)
        }"
      end
      if task.deadline_at.present?
        notes += "\nDeadline At: #{
          I18n.l(task.deadline_at, format: :iso_8601)
        }"
      end
      if task.prioritize_at.present?
        notes += "\nPrioritize At: #{
          I18n.l(task.prioritize_at, format: :iso_8601)
        }"
      end
      if task.remind_me_at.present?
        notes += "\nRemind Me At: #{
          I18n.l(task.remind_me_at, format: :iso_8601)
        }"
      end
      if task.review_at.present?
        notes += "\nReview At: #{
          I18n.l(task.review_at, format: :iso_8601)
        }"
      end
      # rubocop:enable Naming/VariableNumber

      InboxItem.create!(
        {
          user:      task.user,
          title:     task.title,
          notes:     notes
        }
      )
    end

    ##########################
    ## Drop obsolete tables ##
    ##########################

    drop_table :rules
    drop_table :taggings
    drop_table :tags
    drop_table :tasks
    drop_table :lists
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
      'Implementing the inverse of this isn\'t worth the effort at time of '\
      'writing. Update the down and run again if needed.'
  end
end
# rubocop:enable Metrics
