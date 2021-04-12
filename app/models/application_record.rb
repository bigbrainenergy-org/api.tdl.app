class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def _write_attribute(attr_name, value)
    if value.is_a?(String) && value.present?
      super(attr_name, value.delete("\u0000"))
    else
      super
    end
  end
end
