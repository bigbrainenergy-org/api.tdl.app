class User < ApplicationRecord
  authenticates_with_sorcery!

  ###############
  ## Constants ##
  ###############

  DEFAULT_CONTEXTS = [
    { title: 'At Phone' },
    { title: 'At Computer' },
    { title: 'At Home' },
    { title: 'At Office' },
    { title: 'Errands' },
    { title: 'Agenda' }
  ]

  ##################
  ## Associations ##
  ##################

  has_many :devices,       dependent: :destroy
  has_many :user_sessions, dependent: :destroy

  has_many :inbox_items,   dependent: :destroy
  has_many :next_actions,  dependent: :destroy
  has_many :waiting_fors,  dependent: :destroy
  has_many :projects,      dependent: :destroy

  has_many :contexts,      dependent: :destroy

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

  ###############
  ## Callbacks ##
  ###############

  after_create :prepopulate_contexts!

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

  def prepopulate_contexts!
    return if contexts.any?

    DEFAULT_CONTEXTS.each do |context|
      Context.create!(
        user: self,
        title: context[:title]
      )
    end
  end
end
