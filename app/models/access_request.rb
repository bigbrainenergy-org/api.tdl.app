class AccessRequest < ApplicationRecord
  enum version: { alpha: 'alpha', beta: 'beta', release: 'release' }

  validates :email,
    presence:         true,
    email_formatting: true,
    uniqueness:       { case_sensitive: false }

  validates :name, :reason_for_interest, :version,
    presence: true
end
