class MetaController < ApplicationController
  skip_before_action :require_login

  # TODO: Return a non-static value to cache bust
  def health
    User.any? # Force a DB connection to see if the database is healthy
  rescue StandardError
    service_unavailable
  end

  def time_zones
    @time_zones = ActiveSupport::TimeZone.all.map do |time_zone|
      {
        name:  time_zone.name,
        value: time_zone.tzinfo.name
      }
    end
  end

  def locales
    @locales = I18n.available_locales.map do |locale|
      {
        code: locale.to_s,
        name: I18n.t('language', locale: locale)
      }
    end
  end
end
