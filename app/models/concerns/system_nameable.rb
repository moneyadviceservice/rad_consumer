module SystemNameable
  extend ActiveSupport::Concern

  class_methods do
    def system_name(id)
      order = find(id).order
      self::SYSTEM_NAMES.fetch(order, :not_found)
    end
  end
end
