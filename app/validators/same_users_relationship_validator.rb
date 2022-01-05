class SameUsersRelationshipValidator < RelationshipValidator
  def validate(record)
    return if record.try(@first)&.user == record.try(@second)&.user

    record.errors.add(:base, I18n.t('validators.same_users_relationship.invalid'))
  end
end
