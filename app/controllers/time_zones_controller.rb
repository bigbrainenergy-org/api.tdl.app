class TimeZonesController < ApplicationController
  def index
    @time_zones = ActiveSupport::TimeZone.all.map do |time_zone|
      {
        name:  time_zone.name,
        value: time_zone.tzinfo.name
      }
    end
  end
end
