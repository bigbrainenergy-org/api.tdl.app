class User < ApplicationRecord
  authenticates_with_sorcery!

  ##################
  ## Associations ##
  ##################

  has_many :devices,       dependent: :destroy
  has_many :lists,         dependent: :destroy
  has_many :tags,          dependent: :destroy
  has_many :user_sessions, dependent: :destroy

  has_many :tasks, through: :lists

  ########################
  ## Virtual Attributes ##
  ########################

  # Sorcery creates a `:password` virtual attribute for us.

  attr_accessor :bypass_password

  #################
  ## Validations ##
  #################

  validates :username,
    length:              { maximum: 69 },
    presence:            true,
    username_formatting: true

  validates :email,
    presence:         true,
    email_formatting: true

  validates :time_zone,
    presence:  true,
    time_zone: true

  validates :locale,
    presence:            true,
    locale_availability: true

  validates :given_name, :family_name,
    presence: true

  validates :terms_and_conditions,
    presence: true

  #############################
  ## Conditional Validations ##
  #############################

  validates :password,
    presence: true,
    length:   { minimum: 14, maximum: 128 },
    if:       lambda {
                (
                  (new_record? && !bypass_password?) ||
                  changes[:password_digest]
                )
              }

  # Only validate uniqueness if we're creating a new user, or editing said
  # field. This saves needing a query every time you validate a user, without
  # losing any functionality.

  validates :username,
    uniqueness: { case_sensitive: false },
    if:         -> { new_record? || changes[:username] }

  validates :email,
    uniqueness: { case_sensitive: false },
    if:         -> { new_record? || changes[:email] }

  ######################
  ## Instance Methods ##
  ######################

  def bypass_password?
    !!bypass_password
  end

  def js_time_zone
    return nil if time_zone.blank?

    ActiveSupport::TimeZone[time_zone].tzinfo.name
  end

  def owner_of?(record)
    record&.user == self
  end
end
