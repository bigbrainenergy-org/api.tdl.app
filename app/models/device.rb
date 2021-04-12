class Device < ApplicationRecord
  belongs_to :user

  validates :push_endpoint, :push_p256dh, :push_auth,
    presence: true

  validates :user_agent, :last_seen_at,
    presence: true
end
